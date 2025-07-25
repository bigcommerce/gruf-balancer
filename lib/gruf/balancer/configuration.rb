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
    # Represents configuration settings for the system
    #
    module Configuration
      VALID_CONFIG_KEYS = {}.freeze

      attr_accessor(* VALID_CONFIG_KEYS.keys)

      ##
      # Whenever this is extended into a class, setup the defaults
      #
      def self.extended(base)
        base.reset
      end

      ##
      # Yield self for ruby-style initialization
      #
      # @yields [Gruf::Balancer::Configuration] The configuration object
      # @return [Gruf::Balancer::Configuration] The configuration object
      #
      def configure
        yield self
      end

      ##
      # Return the current configuration options as a Hash
      #
      # @return [Hash] The configuration represented as a Hash
      #
      def options
        opts = {}
        VALID_CONFIG_KEYS.each_key do |k|
          opts.merge!(k => send(k))
        end
        opts
      end

      ##
      # Set the default configuration onto the extended class
      #
      # @return [Hash] options The reset options hash
      #
      def reset
        VALID_CONFIG_KEYS.each do |k, v|
          send(:"#{k}=", v)
        end
        options
      end
    end
  end
end
