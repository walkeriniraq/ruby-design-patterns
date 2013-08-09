require 'rspec'
require 'strategy'

describe StrategyWithMixin do
  context 'when given a strategy context' do
    subject(:context) { StrategyWithMixin::Context.new(8, 4) }

    describe 'include strategy A' do
      it 'executes the proper strategy' do
        context.extend StrategyWithMixin::A
        context.execute.should == 12
      end
    end
    describe 'include strategy B' do
      it 'executes the proper strategy' do
        context.extend StrategyWithMixin::B
        context.execute.should == 4
      end
    end
    describe 'change the strategy' do
      it 'executes the proper strategy' do
        context.extend StrategyWithMixin::B
        context.execute.should == 4
        context.extend StrategyWithMixin::A
        context.execute.should == 12
      end
    end
  end
end

describe StrategyWithClass do
  context 'when given a strategy context' do
    subject(:context) { StrategyWithClass::Context.new(8, 4) }

    describe 'include strategy A' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithClass::A
        context.execute.should == 12
      end
    end
    describe 'include strategy B' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithClass::B
        context.execute.should == 4
      end
    end
    describe 'change the strategy' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithClass::B
        context.execute.should == 4
        context.set_strategy StrategyWithClass::A
        context.execute.should == 12
      end
    end
  end
end

describe StrategyWithDelegate do
  context 'when given a strategy context' do
    subject(:context) { StrategyWithDelegate::Context.new(8, 4) }

    describe 'include strategy A' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithDelegate::A
        context.execute.should == 12
      end
    end
    describe 'include strategy B' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithDelegate::B
        context.execute.should == 4
      end
    end
    describe 'change the strategy' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithDelegate::B
        context.execute.should == 4
        context.set_strategy StrategyWithDelegate::A
        context.execute.should == 12
      end
    end
  end
end

describe StrategyWithBlock do
  context 'when given a strategy context' do
    subject(:context) { StrategyWithBlock::Context.new(8, 4) }

    describe 'include strategy A' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithBlock::A
        context.execute.should == 12
      end
    end
    describe 'include strategy B' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithBlock::B
        context.execute.should == 4
      end
    end
    describe 'change the strategy' do
      it 'executes the proper strategy' do
        context.set_strategy StrategyWithBlock::B
        context.execute.should == 4
        context.set_strategy StrategyWithBlock::A
        context.execute.should == 12
      end
    end
  end
end
