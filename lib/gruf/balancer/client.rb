# frozen_string_literal: true

# Copyright (c) 2021-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
module Gruf
  module Balancer
    ##
    # Thread-safe class that allows percentage-based balancing of calls to a given pool of clients
    #
    class Client
      ##
      # @param [GRPC::GenericService] service The gRPC Service stub to use when creating clients in this pool
      # @param [Hash] options A default set of options to pass through to all Gruf::Clients in this balanced pool
      # @param [Hash] client_options A default set of gRPC client options to pass through to all Gruf::Clients in this
      #   balanced pool
      #
      def initialize(service:, options: {}, client_options: {})
        super()
        @service = service
        @options = options
        @client_options = client_options
        @pool = ::Concurrent::Hash.new
        @sampler = ->(pool) { pool.max_by { |_, w| rand**(1.0 / w) }.first }
      end

      ##
      # Create a client and add it to the pool at a given percentage of requests. If the percentage given is outside of
      # 0-100, it will automatically constrain it to the max of 100.0 or minimum of 0.0.
      #
      # @param [Float] percentage The percentage of requests to weight by (0-100)
      # @param [Hash] options Options to pass-through to the Gruf::Client
      # @param [Hash] client_options gRPC Client Options to pass-through to the Gruf::Client
      # @param [Class] client_class The client class to use. Useful if wanting to create a Gruf::SynchronizedClient or
      #   other derivative client
      #
      def add_client(percentage:, options: {}, client_options: {}, client_class: nil)
        client_class ||= ::Gruf::Client
        percentage = percentage > 100.0 ? 100.0 : percentage.to_f
        percentage = percentage < 0.0 ? 0.0 : percentage
        cl = client_class.new(
          service: @service,
          options: @options.merge(options),
          client_options: @client_options.merge(client_options)
        )
        @pool[cl] = percentage.to_f / 100.0
      end

      ##
      # Pick a sampled client from the pool based on the weighted percentages entered
      #
      # @return [::Gruf::Client]
      #
      def pick
        @sampler[@pool]
      end

      ##
      # Delegate the call to the sampled client
      #
      # @return [Gruf::Response]
      #
      def call(*args, &)
        pick.call(*args, &)
      end
    end
  end
end
