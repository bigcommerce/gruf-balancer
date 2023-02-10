#!/usr/bin/env ruby
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
require_relative 'config'

Gruf.logger.level = Logger::Severity::DEBUG
client = Gruf::Balancer::Client.new(service: ::TestService)
client.add_client(percentage: 60.0, options: { hostname: '127.0.0.1:8000' })
client.add_client(percentage: 40.0, options: { hostname: '127.0.0.1:8001' })

buckets = {}
TOTAL_RUNS = 100
TOTAL_RUNS.times do
  resp = client.call(:Run)
  buckets[resp.message.host] ||= 0
  buckets[resp.message.host] += 1
  Gruf.logger.info "Response: #{resp.message}"
  sleep 0.01
end

Gruf.logger.info "Ran #{TOTAL_RUNS} requests. Distribution:"
buckets.each do |host, total|
  percentage = ((total.to_f / TOTAL_RUNS.to_f) * 100.0).round(2)
  Gruf.logger.info "- #{host}: #{total} - #{percentage}%"
end
