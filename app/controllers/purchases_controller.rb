class PurchasesController < ApplicationController

  def index
    @purchases = Purchase.includes(:merchant, :customer, :item).all
  end

end
