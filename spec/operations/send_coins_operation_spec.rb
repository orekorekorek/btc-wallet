RSpec.describe SendCoinsOperation do
  let(:call) do
    described_class.new(
      '7cfbcb519318b7b0960e03fcfc346e6dd5bf740da58070f341630d9ea3a0af82',
      'mrXfk2NNR2wgg6RQerdh5F5LFa98rTML6M',
      0.00001
    ).call
  end

  around do |example|
    VCR.use_cassette('broadcast_transaction') do
      example.run
    end
  end

  describe '#call' do
    it 'broadcasts transaction' do
      expect(call).to be_a(String)
    end
  end
end
