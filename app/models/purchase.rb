class Purchase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
  belongs_to :item

  def total
    item.price * quantity
  end
end
