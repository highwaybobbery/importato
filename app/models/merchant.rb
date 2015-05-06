class Merchant < ActiveRecord::Base
  has_many :items
  has_many :purchases

  def to_s
    "#{name}, #{address}"
  end
end
