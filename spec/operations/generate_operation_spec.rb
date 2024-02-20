RSpec.describe GenerateOperation do
  let(:operation) { described_class.new }

  describe '#call' do
    subject(:call) { operation.call }
    let(:key) { instance_double(Bitcoin::Key, key: 'random_key', addr: 'random_address') }

    before do
      allow(Bitcoin::Key).to receive(:generate).and_return(key)
      allow(File).to receive(:open).with(GenerateOperation::KEY_PATH, 'w')
    end

    it 'saves private key to file' do
      call

      expect(File).to have_received(:open)
    end

    it 'returns key address' do
      expect(call).to eq('random_address')
    end
  end
end
