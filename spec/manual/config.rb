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
require 'rubygems'
require 'bundler'
Bundler.setup
require 'active_support/all'
require 'gruf'
require 'gruf/balancer'
require_relative '../pb/test_controller'

Gruf.configure do |c|
  c.server_binding_url = ENV.fetch('GRPC_SERVER_URL', '127.0.0.1:8001')
  c.backtrace_on_error = true
  c.interceptors.use(
    Gruf::Interceptors::Instrumentation::RequestLogging::Interceptor,
    formatter: :plain,
    log_parameters: true
  )
end

Gruf.logger = Logger.new($stdout)
Gruf.logger.level = Logger::Severity::INFO
Gruf.grpc_logger = Logger.new($stdout)
Gruf.grpc_logger.level = Logger::Severity::WARN
Gruf.services << ::TestService::Service
