# gruf-balancer - Testing framework for Gruf Clients

[![CircleCI](https://circleci.com/gh/bigcommerce/gruf-balancer/tree/main.svg?style=svg)](https://circleci.com/gh/bigcommerce/gruf-balancer/tree/main) [![Gem Version](https://badge.fury.io/rb/gruf-balancer.svg)](https://badge.fury.io/rb/gruf-balancer)

[![Maintainability](https://api.codeclimate.com/v1/badges/5644b038f277f345d0b3/maintainability)](https://codeclimate.com/github/bigcommerce/gruf-balancer/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/5644b038f277f345d0b3/test_coverage)](https://codeclimate.com/github/bigcommerce/gruf-balancer/test_coverage) 

Provides an integration for [gruf](https://github.com/bigcommerce/gruf) Ruby gRPC framework, allowing testing 
various outbound `Gruf::Client` calls on a percentage-basis, letting you balance requests between multiple clients 
for testing new services, code paths, or networking operations.

## Installation

```ruby
gem 'gruf-balancer'
```

## Usage

Instead of creating a normal `Gruf::Client`, simply add clients to a `Gruf::Balancer::Client`, via passing in
a percentage of requests and client options (similarly to how you'd create `Gruf::Client` objects).

```ruby
client = Gruf::Balancer::Client.new(service: MyService)
client.add_client(percentage: 60, options: { hostname: '127.0.0.1:8000' })
client.add_client(percentage: 40, options: { hostname: '127.0.0.1:8001' })
# @type [Gruf::Response] resp
resp = client.call(:GetThing, id: 123)
```

This uses a weighted random sampling algorithm under the hood to balance the requests to the method on the defined
percentage weights. In the example above, 60% of requests would go to our service on port 8000, and 40% on port 8001.

`Gruf::Balancer::Client` acts similarly to a `Gruf::Client`, in terms of its `call` method signature. It maintains
a thread-safe pool of clients. Note, similarly to gRPC core, that clients are not fork-safe; please instantiate
any balanced client pools _after_ forking.

### Use Cases

Some use cases for gruf-balancer can be:

* Testing a new application service that serves the same gRPC Service, but on a different hostname
* Testing different hostnames, routing rules, network infrastructure, or service meshes via different hostnames 
* Testing new client options, such as timeouts, credentials, channels, or channel arguments
* Testing new client interceptors, since they are configured per-client

## License

Copyright (c) 2021-present, BigCommerce Pty. Ltd. All rights reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
