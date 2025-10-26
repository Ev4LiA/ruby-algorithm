class SimpleBankSystem
  attr_accessor :balance

  # @param balance [Integer[]]
  def initialize(balance)
    @balance = balance
  end

  # @param account1 [Integer]
  # @param account2 [Integer]
  # @param money [Integer]
  # @return [Boolean]
  def transfer(account1, account2, money)
    return false if account1 > balance.length || account2 > balance.length || balance[account1 - 1] < money

    balance[account1 - 1] -= money
    balance[account2 - 1] += money
    true
  end

  # @param account [Integer]
  # @param money [Integer]
  # @return [Boolean]
  def deposit(account, money)
    return false if account > balance.length

    balance[account - 1] += money
    true
  end

  # @param account [Integer]
  # @param money [Integer]
  # @return [Boolean]
  def withdraw(account, money)
    return false if account > balance.length || balance[account - 1] < money

    balance[account - 1] -= money
    true
  end
end

# Your Bank object will be instantiated and called as such:
# obj = Bank.new(balance)
# param_1 = obj.transfer(account1, account2, money)
# param_2 = obj.deposit(account, money)
# param_3 = obj.withdraw(account, money)
