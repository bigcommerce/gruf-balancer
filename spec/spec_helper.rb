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
$LOAD_PATH.unshift File.expand_path('../lib', __dir__.to_s)
require_relative 'simplecov_helper'
require 'gruf/balancer'
require 'pry'

Dir["#{File.join(__dir__.to_s, 'support')}/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.before do
    Gruf.logger = ::Logger.new(File::NULL) unless ENV.fetch('GRUF_DEBUG', false)
    Gruf.grpc_logger = ::Logger.new(File::NULL) unless ENV.fetch('GRPC_DEBUG', false)
  end
end
