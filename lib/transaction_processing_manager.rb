class TransactionProcessingManager
  include Validator

  EXPECTED_HEADERS = ['purchaser name', 'item description', 'item price',
    'purchase count',  'merchant address',  'merchant name']

  PRICE_INDEX = 2
  COUNT_INDEX = 3

  attr_reader :total_revenue

  def initialize(data)
    @headers = data.shift
    @data = data
    @total_revenue = 0
  end

  def process
    if validate(:validate_headers, 'Wrong columns in file')
      data.each do |row|
        row_processor.process(row)
        record_revenue(row)
      end
    end
    response_message
  end

  protected

  attr_writer :total_revenue

  private

  attr_reader :data, :model_caches, :headers

  def row_processor
    @row_processor ||= TransactionProcessor.new
  end

  def validate_headers
    headers == EXPECTED_HEADERS
  end

  def record_revenue(row)
    self.total_revenue += row[PRICE_INDEX].to_i * row[COUNT_INDEX].to_i
  end

  def response_message
    valid? ? success_message : failure_message
  end

  def success_message
    { success: "You imported $#{total_revenue} worth of transactions" }
  end


end

