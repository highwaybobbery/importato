class ItemsController < ApplicationController

  def index
    @items = Item.includes(:merchant).all
  end

end
