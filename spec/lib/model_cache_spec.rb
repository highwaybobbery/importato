require 'rails_helper'

describe ModelCache do
  let(:model_class){ double :model_class, find_or_create_by: model_instance }
  let(:model_instance){ double :instance, id: 2 }
  let(:cache){ ModelCache.new(model_class) }
  let(:attributes){{ some_attr: 'turkey', other_attr: 'potato' }}

  describe 'write' do

    context 'when the cache has a record of the attributets' do
      before { cache.write(attributes) }

      it 'does not write to the factory' do
        expect(model_class).not_to receive(:find_or_create_by)
        cache.write(attributes)
      end

      it 'returns the id' do
        expect(cache.write(attributes)).to eq(2)
      end
    end

    context 'when the cache does not have a record of the name and address' do
      it 'writes to the factory' do
        expect(model_class).to receive(:find_or_create_by).
          with(attributes).and_return(model_instance)
        cache.write(attributes)
      end

      it 'returns the id' do
        expect(cache.write(attributes)).to eq(2)
      end
    end

  end
end
