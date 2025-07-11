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
$LOAD_PATH.push(File.expand_path('lib', __dir__.to_s))
require 'gruf/balancer/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-balancer'
  spec.version       = Gruf::Balancer::VERSION
  spec.authors       = ['Shaun McCormick']
  spec.email         = ['splittingred@gmail.com']
  spec.licenses      = ['MIT']

  spec.summary       = 'Allows for percentage-based balancing of gruf client calls'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/bigcommerce/gruf-balancer'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-balancer.gemspec']
  spec.require_paths = %w[lib]
  spec.required_ruby_version = '>= 3.2', '< 4'

  spec.add_dependency 'concurrent-ruby', '> 1'
  spec.add_dependency 'gruf', '> 2.8'
  spec.add_dependency 'logger'
  spec.add_dependency 'rake', '>= 12.3'
end
