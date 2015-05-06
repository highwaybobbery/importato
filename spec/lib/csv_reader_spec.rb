require 'rails_helper'

describe CSVReader do
  describe 'read' do

    context 'when the file does not exist' do
      it 'returns failure with a file not found message' do
        importer = CSVReader.new('missing_file.csv')
        importer.read
        expect(importer.failure_message).to eq({ error: 'File not found' })
      end
    end

    context 'when the file exists' do

      context 'and is not a csv file' do
        it 'returns a failure with an invalid file message' do
          importer = CSVReader.new('spec/fixtures/invalid_file.jpg')
          importer.read
          expect(importer.failure_message).to eq({ error: 'Invalid file' })
        end
      end

      context 'and is a malformed csv file' do
        it 'returns a failure with an invalid file message' do
          importer = CSVReader.new('spec/fixtures/malformed.csv')
          importer.read
          expect(importer.failure_message).to eq({ error: 'Invalid file' })
        end
      end

      context 'and is a valid csv file' do
        it 'returns the data from the file in arrays' do
          importer = CSVReader.new('spec/fixtures/valid_csv.csv')
          csv_data = [['head_one', 'head_two'], ['data_one', 'data_two']]
          expect(importer.read).to eq(csv_data)
        end
      end

      context 'and is a valid tsv file' do
        it 'returns the data from the file in arrays' do
          importer = CSVReader.new('spec/fixtures/valid_tsv.tsv')
          csv_data = [['head_one', 'head_two'], ['data_one', 'data_two']]
          expect(importer.read).to eq(csv_data)
        end
      end

    end
  end
end
