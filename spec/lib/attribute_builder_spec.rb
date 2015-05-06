require 'rails_helper'

describe AttributeBuilder do
  let(:builder){ AttributeBuilder.new }

  let(:row){ ['bilbo baggins', 'shiny ring', '10', '1',  'Lonely Mtn',  'Smaug'] }

  let(:merchant_attributes) {{ name: 'Smaug', address: 'Lonely Mtn' }}
  let(:customer_attributes) {{ name: 'bilbo baggins' }}
  let(:item_attributes) {{ description: 'shiny ring', price: '10', merchant_id: 2 }}
  let(:purchase_attributes) {{ quantity: '1', merchant_id: 2, customer_id: 3, item_id: 4 }}

  describe 'attributes_for' do
    context 'for Merchant' do
      it 'returns the correct attributes' do
        expect(builder.attributes_for 'Merchant', row).to eq(merchant_attributes)
      end
    end

    context 'for Customer' do
      it 'returns the correct attributes' do
        expect(builder.attributes_for 'Customer', row).to eq(customer_attributes)
      end
    end

    context 'for Item' do
      it 'returns the correct attributes' do
        expect(builder.attributes_for 'Item', row, merchant_id: 2).to eq(item_attributes)
      end
    end

    context 'for Purchase' do
      it 'returns the correct attributes' do
        ids = { merchant_id: 2, customer_id: 3, item_id: 4 }
        expect(builder.attributes_for 'Purchase', row, ids).to eq(purchase_attributes)
      end
    end

  end
end
