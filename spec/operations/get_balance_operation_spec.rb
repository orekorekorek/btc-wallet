RSpec.describe GetBalanceOperation do
  around do |example|
    VCR.use_cassette('get_utxos') do
      example.run
      @balance = described_class.call('mjrFHUTszcjByUjVQ7gRiB2BVkyJUNe6NS')
    end
  end

  describe '#call' do
    context 'when address is valid' do
      subject(:call) { described_class.call('mjrFHUTszcjByUjVQ7gRiB2BVkyJUNe6NS') }

      it 'returns balance by address as sum of utxos values' do
        expect(call).to be_a(Float)
      end
    end

    context 'when address is invalid' do
      subject(:call) { described_class.call('invalid_address') }

      it 'returns nil' do
        expect(call).to be_nil
      end
    end
  end
end
