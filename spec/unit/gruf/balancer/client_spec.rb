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
require 'spec_helper'

describe Gruf::Balancer::Client do
  let(:options) { {} }
  let(:client_options) { {} }
  let(:client_class) { nil }
  let(:client) { described_class.new(service: TestService, options: options, client_options: client_options) }

  describe '#add_client' do
    subject { client.add_client(percentage: percentage, options: sub_options, client_options: sub_client_options, client_class: Gruf::SynchronizedClient) }

    let(:sub_options) { {} }
    let(:sub_client_options) { {} }
    let(:percentage) { 50.0 }

    let(:pool) { client.instance_variable_get(:@pool) }
    let(:derived_client) { pool.keys.first }
    let(:actual_weight) { pool.values.first }

    context 'with valid values' do
      it 'adds a client to the pool' do
        expect { subject }.not_to raise_error

        expect(derived_client).to be_a(Gruf::Client)
        expect(actual_weight).to eq percentage / 100.0
      end
    end

    context 'if the passed percentage is under 0' do
      let(:percentage) { -1.0 }

      it 'sets the weight to 0.0' do
        expect { subject }.not_to raise_error

        expect(derived_client).to be_a(Gruf::Client)
        expect(actual_weight).to eq 0.0
      end
    end

    context 'if the passed percentage is over 100.0' do
      let(:percentage) { 101.0 }

      it 'sets the weight to 1.0' do
        expect { subject }.not_to raise_error

        expect(derived_client).to be_a(Gruf::Client)
        expect(actual_weight).to eq 1.0
      end
    end

    context 'with a custom client class' do
      let(:client_class) { Gruf::SynchronizedClient }

      it 'creates the client with the custom class' do
        expect { subject }.not_to raise_error

        expect(derived_client).to be_a(Gruf::SynchronizedClient)
      end
    end
  end

  describe '#call' do
    subject { client.call(:Run) }

    before do
      client.add_client(percentage: 50.0)
      client.add_client(percentage: 50.0)
    end

    it 'delegates it to a picked client' do
      expect_any_instance_of(Gruf::Client).to receive(:call).once
      subject
    end
  end
end
