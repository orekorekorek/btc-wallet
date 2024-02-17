require_relative 'callable'
require 'bitcoin'
require 'http'

Bitcoin.network = :testnet3

class BaseOperation
  extend Callable

  BLOCKSTREAM_API_BASE_URL = 'https://blockstream.info/testnet/api/'.freeze
  SATOSHIS_IN_BTC = 100_000_000

  def call
    raise NotImplementedError
  end

  private

  def utxos
    @utxos ||= get_utxos
  end

  def get_utxos
    response = HTTP.get(utxos_url)
    validate_response(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def utxos_url
    "#{BLOCKSTREAM_API_BASE_URL}/address/#{address}/utxo"
  end

  def address
    raise NotImplementedError
  end

  def convert_satoshis_to_btc(satoshis)
    satoshis.to_f / SATOSHIS_IN_BTC
  end

  def validate_response(response)
    raise "BlockStreamApi error: #{response.status.reason}" unless response.status.success?
  end
end
