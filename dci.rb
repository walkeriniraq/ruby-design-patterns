require 'delegate'

class Account
  attr_accessor :balance
  def initialize(balance)
    @balance = balance
  end
end

module DciViaDelegate
  class TransferContext
    class FromAccount < SimpleDelegator
      def withdraw(amount)
        raise 'Amount exceeds balance' if amount > balance
        self.balance -= amount
      end
    end

    class ToAccount < SimpleDelegator
      def deposit(amount)
        self.balance += amount
      end
    end

    def initialize(from, to, amount)
      @amount = amount
      @from = FromAccount.new(from)
      @to = ToAccount.new(to)
    end

    def call
      @from.withdraw @amount
      @to.deposit @amount
    end
  end
end

module DciViaInclude
  class TransferContext
    module FromAccount
      def withdraw(amount)
        raise 'Amount exceeds balance' if amount > balance
        self.balance -= amount
      end
    end

    module ToAccount
      def deposit(amount)
        self.balance += amount
      end
    end

    def initialize(from, to, amount)
      @amount = amount
      @from = from.extend FromAccount
      @to = to.extend ToAccount
    end

    def call
      @from.withdraw @amount
      @to.deposit @amount
    end
  end
end

if __FILE__ == $0
  require 'benchmark'

  iterations = 100_000

  Benchmark.bmbm(20) do |bm|
    bm.report('DCI via instance include') do
      iterations.times do
        from = Account.new 1000
        to = Account.new 100
        dci_context = DciViaInclude::TransferContext.new from, to, 500
        dci_context.call
      end
    end

    bm.report('DCI via delegate') do
      iterations.times do
        from = Account.new 1000
        to = Account.new 100
        dci_context = DciViaDelegate::TransferContext.new from, to, 500
        dci_context.call
      end
    end
  end
end