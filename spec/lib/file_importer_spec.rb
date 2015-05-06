require 'rails_helper'

describe FileImporter do
  describe 'import!' do
    let(:file_path){ 'path/to/somefile.csv' }
    let(:importer){ FileImporter.new(file_path) }
    let(:csv_data){ [['some_header'], ['some data']] }
    let(:csv_reader){ double :csv_reader, read: csv_data }
    let(:success_message){{ success: 'Import successful' }}
    let(:manager){
      double :transaction_manager, process: success_message
    }

    it 'reads the file with CSVReader' do
      expect(CSVReader).to receive(:new).with(file_path).and_return csv_reader
      importer.import!
    end

    it 'processes the data from the csv' do
      allow(CSVReader).to receive(:new).with(file_path).and_return csv_reader
      allow(csv_reader).to receive(:read).and_return csv_data
      expect(TransactionProcessingManager).to receive(:new).with(csv_data).and_return manager
      allow(manager).to receive(:sucess_message)
      expect(manager).to receive(:process)
      importer.import!
    end

    context 'when the file is not valid csv' do
      it 'returns an error message' do
        msg = { failure: 'bad file'}
        allow(CSVReader).to receive(:new).with(file_path).and_return csv_reader
        allow(csv_reader).to receive(:read).and_return false
        allow(csv_reader).to receive(:failure_message).and_return msg
        expect(importer.import!).to eq(msg)
      end
    end

    context 'when the import is successful' do
      it 'returns the import managers response' do
        allow(CSVReader).to receive(:new).with(file_path).and_return csv_reader
        allow(csv_reader).to receive(:read).and_return csv_data
        allow(TransactionProcessingManager).to receive(:new).with(csv_data).and_return manager
        expect(importer.import!).to eq(success_message)
      end
    end

  end
end
