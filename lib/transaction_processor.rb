class TransactionProcessor

  def process(row)
    merchant_id = write_model('Merchant', row)
    customer_id = write_model('Customer', row)
    item_id = write_model('Item', row, merchant_id: merchant_id)

    write_model('Purchase', row,
      merchant_id: merchant_id,
      customer_id: customer_id,
      item_id: item_id
    )
  end

  private

  attr_reader :model_writers, :purchase_factory

  def write_model(klass, row, relation_ids = {})
    model_writers[klass].write(
      attribute_builder.attributes_for(klass, row, relation_ids)
    )
  end

  def model_writers
    @model_writers ||= {
      'Merchant' => ModelCache.new(Merchant),
      'Customer' => ModelCache.new(Customer),
      'Item' => ModelCache.new(Item),
      'Purchase' => PurchaseFactory.new
    }
  end

  def attribute_builder
    @attribute_builder ||= AttributeBuilder.new
  end

end
