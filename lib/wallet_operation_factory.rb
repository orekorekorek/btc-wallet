Dir[File.join(__dir__, 'operations', '*_operation.rb')].each { |f| require f }

class WalletOperationFactory
  def self.execute(command_name, *args)
    case command_name
    when :generate
      GenerateOperation.()
    when :get_balance
      GetBalanceOperation.(*args)
    when :send_coins
      SendCoinsOperation.(*args)
    else
      BaseOperation.()
    end
  end
end
