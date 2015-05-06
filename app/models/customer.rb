class Customer < ActiveRecord::Base
  has_many :purchases

  def to_s
    name
  end
end
