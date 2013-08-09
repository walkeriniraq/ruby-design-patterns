module Strategy
  class Context
    attr_accessor :arg_one, :arg_two

    def initialize(val_one, val_two)
      @arg_one = val_one
      @arg_two = val_two
    end

  end
end

module StrategyWithBlock
  class Context < Strategy::Context
    def initialize(a, b)
      super
      @strategy = DEFAULT_PROC
    end

    def set_strategy(proc)
      @strategy = proc
    end

    def execute
      self.instance_eval &@strategy
    end
  end

  DEFAULT_PROC = Proc.new do
    raise 'No default strategy'
  end

  A = Proc.new do
    arg_one + arg_two
  end

  B = Proc.new do
    arg_one - arg_two
  end
end

module StrategyWithClass
  class Context < Strategy::Context
    def initialize(a, b)
      super
      @strategy = DefaultStrategy.new self
    end

    def set_strategy(strategy_class)
      @strategy = strategy_class.new self
    end

    def execute
      @strategy.execute
    end
  end

  class DefaultStrategy
    def initialize(obj)
      @__context_obj__ = obj
    end

    def execute
      raise 'No default strategy'
    end
  end

  class A < DefaultStrategy
    def execute
      @__context_obj__.arg_one + @__context_obj__.arg_two
    end
  end

  class B < DefaultStrategy
    def execute
      @__context_obj__.arg_one - @__context_obj__.arg_two
    end
  end
end

module StrategyWithDelegate
  class Context < Strategy::Context
    def initialize(a, b)
      super
      @strategy = DefaultStrategy.new(self)
    end

    def set_strategy(strategy_class)
      @strategy = strategy_class.new self
    end

    def execute
      @strategy.execute
    end
  end

  require 'delegate'
  class DefaultStrategy < SimpleDelegator
    def initialize(obj)
      super(obj)
    end

    def execute
      raise 'No default strategy'
    end
  end

  class A < DefaultStrategy
    def execute
      arg_one + arg_two
    end
  end

  class B < DefaultStrategy
    def execute
      arg_one - arg_two
    end
  end
end

module StrategyWithMixin
  class Context < Strategy::Context
    def execute
      raise 'No default strategy'
    end
  end

  module A
    def execute
      arg_one + arg_two
    end
  end

  module B
    def execute
      arg_one - arg_two
    end
  end
end

if __FILE__ == $0
  require 'benchmark'

  iterations = 100_000

  Benchmark.bmbm(20) do |bm|
    bm.report('Strategy with mixin') do
      context = StrategyWithMixin::Context.new(6, 3)
      iterations.times do
        context.extend StrategyWithMixin::B
        context.execute
        context.extend StrategyWithMixin::A
        context.execute
      end
    end

    bm.report('Strategy with block') do
      context = StrategyWithBlock::Context.new(6, 3)
      iterations.times do
        context.set_strategy StrategyWithBlock::B
        context.execute
        context.set_strategy StrategyWithBlock::A
        context.execute
      end
    end

    bm.report('Strategy with class') do
      context = StrategyWithClass::Context.new(6, 3)
      iterations.times do
        context.set_strategy StrategyWithClass::B
        context.execute
        context.set_strategy StrategyWithClass::A
        context.execute
      end
    end

    bm.report('Strategy with delegate') do
      context = StrategyWithDelegate::Context.new(6, 3)
      iterations.times do
        context.set_strategy StrategyWithDelegate::B
        context.execute
        context.set_strategy StrategyWithDelegate::A
        context.execute
      end
    end
  end
end