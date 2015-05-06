require 'rails_helper'

describe Validator do
  let(:dummy_class) do
    klass = Class.new { include Validator }
    klass.send(:define_method, 'some_validation') {}
    klass.send(:define_method, 'some_other_validation') {}
    klass
  end
  let(:instance) { dummy_class.new }

  describe 'validate' do
    it 'calls the passed validation method' do
      expect(instance).to receive(:some_validation)
      instance.validate(:some_validation, 'some message')
    end

    context 'when the validation method returns false' do
      before do
        allow(instance).to receive(:some_validation).and_return false
      end

      it 'sets the failure message' do
        instance.validate('some_validation', 'some message')
        expect(instance.failure_message).to eq({ error: 'some message' })
      end

      it 'sets the failed flag' do
        instance.validate('some_validation', 'some message')
        expect(instance.failed?).to eq(true)
      end

      it 'returns false' do
        return_value = instance.validate('some_validation', 'some message')
        expect(return_value).to eq(false)
      end
    end

    context 'when the validation method returns true' do
      before do
        allow(instance).to receive(:some_validation).and_return true
        instance.validate('some_validation', 'some message')
      end

      it 'sets the failure message' do
        expect(instance.failure_message).to eq(nil)
      end

      it 'sets the failed flag' do
        expect(instance.failed?).to eq(false)
      end

      it 'returns true' do
        return_value = instance.validate('some_validation', 'some message')
        expect(return_value).to eq(true)
      end
    end

    context 'when a validation has already faileded' do
      it 'does not call the validation method' do
        allow(instance).to receive(:failed?).and_return true
        expect(instance).not_to receive(:some_validation)
        instance.validate(:some_validation, 'some message')
      end

      it 'does not change the validation message' do
        allow(instance).to receive(:some_other_validation).and_return false
        allow(instance).to receive(:some_validation).and_return false
        instance.validate(:some_other_validation, 'some other message')
        instance.validate(:some_validation, 'some message')

        expect(instance.failure_message).to eq({ error: 'some other message' })
      end
    end

  end
end
