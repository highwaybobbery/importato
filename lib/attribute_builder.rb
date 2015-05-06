class AttributeBuilder

  MODEL_TO_COLUMN_MAP = {
    'Merchant' => { 4 => :address , 5 => :name },
    'Customer' => { 0 => :name },
    'Item' => { 1 => :description, 2 => :price },
    'Purchase' => { 3 => :quantity }
  }

  def attributes_for(klass, row, relation_ids={})
    get_attributes(row, column_map_for(klass)).merge relation_ids
  end

  private

  def column_map_for(klass)
    MODEL_TO_COLUMN_MAP[klass]
  end

  def get_attributes(row, column_map)
    column_map.each_with_object({}) do |(index, attribute), attributes|
      attributes[attribute] = row[index]
    end
  end

end
