require 'optparse'
require_relative 'lib/wallet_operation_factory'

def private_key
  raise <<-ERROR unless File.exist?('.key')
You need to specify wallet first!

Generate it with: wallet.rb --generate
OR
Manually create .key file and put your private key there
  ERROR

  File.read('.key').chomp
end

ARGV << '--help' if ARGV.empty?

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: wallet.rb [options]"

  opts.on('-h', '--help', 'Prints help') { return puts opts }

  opts.on('-g', '--generate', 'generate wallet and save private key to file') do
    address = WalletOperationFactory.execute(:generate)

    puts "New wallet was generated with address: #{address} and saved to .key"
    return
  end

  opts.on('-b', '--balance', 'show wallet balance') do
    address = Bitcoin::Key.new(private_key).addr
    balance = WalletOperationFactory.execute(:get_balance, address)

    puts "Balance ₿: #{balance}"
    return
  end

  opts.on('--amount=AMOUNT', 'the coins amount (in ₿) to send', Float) do |amount|
    options[:amount] = amount
  end

  opts.on('--recipient=ADDRESS', 'the recipient address', String) do |recipient|
    options[:recipient] = recipient
  end
end.parse!

unless options.values_at(:amount, :recipient).all?
  puts 'You need to specify the amount and the recipient address of the transaction'
  return
end

txid = WalletOperationFactory.execute(:send_coins, private_key, options[:recipient], options[:amount])

puts "#{options[:amount]}₿ was sent to #{options[:recipient]}, txid: #{txid}"
