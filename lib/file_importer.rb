class FileImporter
  def initialize(file)
    @file = file
  end

  def import!
    if data = csv_reader.read
      create_processor(data)
      processor.process
    else
      csv_reader.failure_message
    end
  end

  private

  attr_reader :file, :processor

  def csv_reader
    @csv_reader ||= CSVReader.new(file)
  end

  def create_processor(data)
    @processor = TransactionProcessingManager.new(data)
  end
end
