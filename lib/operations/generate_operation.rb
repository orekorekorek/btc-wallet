class GenerateOperation < BaseOperation
  KEY_PATH = File.join(File.expand_path('../..', __dir__), '.key').freeze

  def initialize
    @key = Bitcoin::Key.generate
  end

  def call
    save_private_key_to_file

    key.addr
  end

  private

  attr_reader :key

  def save_private_key_to_file
    File.open(KEY_PATH, 'w') { |file| file.write(key.priv) }
  end
end
