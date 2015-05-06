require 'rails_helper'

describe TransactionProcessingManager do
  let(:valid_header) do
    ['purchaser name', 'item description', 'item price', 'purchase count',  'merchant address',  'merchant name']
  end

  let(:row_a) do
    ['bilbo baggins', 'shiny ring', '10', '1',  'Lonely Mtn',  'Smaug']
  end

  let(:row_b) do
    ['frodo baggins', 'sting', '10', '2',  'gross cave',  'Gandalf']
  end

  describe 'process' do
    context 'when the header is invalid' do
      it 'fails' do
        processor = TransactionProcessingManager.new([['bad header']])
        processor.process
        expect(processor.failed?).to eq(true)
      end

      it 'returns failure with a file not found message' do
        processor = TransactionProcessingManager.new([['bad header']])
        processor.process
        expect(processor.failure_message).to eq({ error: 'Wrong columns in file' })
      end
    end

    context 'when the header is valid' do
      it 'does not fail' do
        processor = TransactionProcessingManager.new([valid_header])
        processor.process
        expect(processor.failed?).to eq(false)
      end

      it 'passes each row to the row processor' do
        processor = TransactionProcessingManager.new([valid_header, row_a, row_b])
        row_processor = double('row_processor')
        allow(processor).to receive(:row_processor).and_return(row_processor)
        expect(row_processor).to receive(:process).with(row_a).once
        expect(row_processor).to receive(:process).with(row_b).once

        processor.process
      end

      it 'returns a message with the total revenue from the import' do
        processor = TransactionProcessingManager.new([valid_header, row_a, row_b])
        row_processor = double('row_processor', process: true)
        allow(processor).to receive(:row_processor).and_return(row_processor)

        expect(processor.process).to eq({:success=>"You imported $30 worth of transactions"})
      end
    end

  end
end
