class Item < ActiveRecord::Base
  belongs_to :merchant
  has_many :purchases

  def to_s
    "#{description}"
  end
end
