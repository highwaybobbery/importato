require 'rails_helper'

describe TransactionProcessor do
  let(:processor) { TransactionProcessor.new }

  let(:row){ ['bilbo baggins', 'shiny ring', '10', '1',  'Lonely Mtn',  'Smaug'] }

  let(:merchant_attributes) {{ name: 'Smaug', address: 'Lonely Mtn' }}
  let(:customer_attributes) {{ name: 'bilbo baggins' }}
  let(:item_attributes) {{ description: 'shiny ring', price: '10', merchant_id: 2 }}
  let(:purchase_attributes) {{ quantity: '1', merchant_id: 2, customer_id: 3, item_id: 4 }}

  let(:merchant_cache){ double :merchant_cache, write: 2 }
  let(:customer_cache){ double :customer_cache, write: 3 }
  let(:item_cache){ double :item_cache, write: 4 }
  let(:purchase_factory){ double :purchase_factory, write: 5 }

  describe 'process' do
    before do
      allow(ModelCache).to receive(:new).with(Merchant).and_return(merchant_cache)
      allow(ModelCache).to receive(:new).with(Customer).and_return(customer_cache)
      allow(ModelCache).to receive(:new).with(Item).and_return(item_cache)
      allow(PurchaseFactory).to receive(:new).and_return(purchase_factory)
    end

    it 'sends the attributes through the merchant cache' do
      expect(merchant_cache).to receive(:write).with(merchant_attributes)
      processor.process(row)
    end

    it 'sends the attributes through the customer cache' do
      expect(customer_cache).to receive(:write).with(customer_attributes)
      processor.process(row)
    end

    it 'sends the attributes and merchant_id through the item cache' do
      expect(item_cache).to receive(:write).with(item_attributes)
      processor.process(row)
    end

    it 'sends the quantity, merchant_id, customer_id, and item_id to the purchase factory' do
      expect(purchase_factory).to receive(:write).with(purchase_attributes)
      processor.process(row)
    end
  end

end
