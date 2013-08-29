require 'rspec'
require 'dci'

describe DciViaInclude do
  context 'with a valid transfer context' do
    subject(:from) { Account.new 1000 }
    subject(:to) { Account.new 100 }
    subject(:dci_context) { DciViaInclude::TransferContext.new from, to, 500 }

    it 'decreases money in the from account' do
      dci_context.call
      expect(from.balance).to eq 500
    end

    it 'increases money in the to account' do
      dci_context.call
      expect(to.balance).to eq 600
    end
  end

  context 'when lacking money in the from account' do
    subject(:from) { Account.new 100 }
    subject(:to) { Account.new 100 }
    subject(:dci_context) { DciViaInclude::TransferContext.new from, to, 500 }

    it 'raises an error' do
      expect { dci_context.call }.to raise_error('Amount exceeds balance')
    end
  end
end

describe DciViaDelegate do
  context 'with a valid transfer context' do
    subject(:from) { Account.new 1000 }
    subject(:to) { Account.new 100 }
    subject(:dci_context) { DciViaDelegate::TransferContext.new from, to, 500 }

    it 'decreases money in the from account' do
      dci_context.call
      expect(from.balance).to eq 500
    end

    it 'increases money in the to account' do
      dci_context.call
      expect(to.balance).to eq 600
    end
  end

  context 'when lacking money in the from account' do
    subject(:from) { Account.new 100 }
    subject(:to) { Account.new 100 }
    subject(:dci_context) { DciViaDelegate::TransferContext.new from, to, 500 }

    it 'raises an error' do
      expect { dci_context.call }.to raise_error('Amount exceeds balance')
    end
  end
end
