#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'config'
require 'benchmark'
require 'benchmark/memory'

n = ENV.fetch('CLIENT_CALLS', 1_000).to_i
Gruf.logger.level = Logger::Severity::DEBUG

client = Gruf::Client.new(service: TestService, options: { hostname: '127.0.0.1:8000' })
balanced_client = Gruf::Balancer::Client.new(service: TestService)
balanced_client.add_client(percentage: 60.0, options: { hostname: '127.0.0.1:8000' })

Gruf.logger.info 'CPU TEST:'

Benchmark.bm do |benchmark|
  benchmark.report('Gruf::Client') do
    n.times do
      client.call(:Run)
    end
  end

  benchmark.report('Gruf::Balancer::Client') do
    n.times do
      balanced_client.call(:Run)
    end
  end
end

Gruf.logger.info 'Memory TEST:'

Benchmark.memory do |benchmark|
  benchmark.report('Gruf::Client') do
    n.times do
      client.call(:Run)
    end
  end

  benchmark.report('Gruf::Balancer::Client') do
    n.times do
      balanced_client.call(:Run)
    end
  end
end

Gruf.logger.info 'Done.'
