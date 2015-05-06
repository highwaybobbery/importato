require 'csv'

class CSVReader
  include Validator

  def initialize(file_path)
    @file_path = file_path
  end

  def read
    validate(:file_exists, 'File not found')
    validate(:read_file, 'Invalid file')

    data
  end

  private

  attr_reader :file_path
  attr_accessor :data

  def file_exists
    File.exists? file_path
  end

  def read_file
    seperator = detect_seperator
    self.data = CSV.read(file_path, col_sep: seperator)
  rescue ArgumentError, CSV::MalformedCSVError
    false
  end

  def detect_seperator
    line = File.open(file_path, &:readline)
    (line.scan(/,/).count < line.scan(/\t/).count) ? "\t" : ','
  end

end
