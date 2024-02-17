class SendCoinsOperation < BaseOperation
  include Bitcoin::Builder

  def initialize(private_key, recipient, amount)
    @key = Bitcoin::Key.new(private_key)
    @address = @key.addr
    @balance = GetBalanceOperation.(@address)
    @recipient = recipient
    @amount = amount
    @total = amount + fee
  end

  def call
    return unless valid?

    broadcast_transaction
  end

  private

  attr_reader :key, :address, :balance, :recipient, :amount, :total

  def valid?
    raise 'Balance is too low' if total > balance
    raise 'Recipient address is invalid' unless Bitcoin.valid_address?(recipient)
    raise 'Amount must be positive' unless amount.positive?

    true
  end

  def broadcast_transaction
    response = HTTP.post(broadcast_url, body: tx.to_payload.unpack('H*')[0])
    validate_response(response)
    response.body
  end

  def tx
    build_tx do |t|
      utxos.each do |utxo|
        t.input do |i|
          i.prev_out prev_tx(utxo[:txid])
          i.prev_out_index utxo[:vout]
          i.signature_key key
        end
      end

      t.output do |o|
        o.value convert_btc_to_satoshis(amount)
        o.script {|s| s.recipient recipient }
      end

      t.output do |o|
        o.value convert_btc_to_satoshis(balance - total)
        o.script {|s| s.recipient address }
      end
    end
  end

  def prev_tx(txid)
    url = "#{BLOCKSTREAM_API_BASE_URL}/tx/#{txid}/raw"
    response = HTTP.get(url)
    validate_response(response)

    Bitcoin::P::Tx.new(response.body.to_s)
  end

  def broadcast_url
    "#{BLOCKSTREAM_API_BASE_URL}/tx"
  end

  def fee
    convert_satoshis_to_btc(utxos.count * 148 + 2 * 34 + 10)
  end

  def convert_btc_to_satoshis(btc)
    btc * SATOSHIS_IN_BTC
  end
end
