# frozen_string_literal: true

require './app/product_information_manager/product_catalogue'

class Checkout
  attr_reader :basket

  def initialize
    @basket = []
    @subtotal = 0
  end

  def scan(item_code)
    item_code.is_a?(Array) ? item_code : item_code = [item_code]
    item_code.each do |item_code|
      item = ProductInformationManager::ProductCatalogue.fetch_item(item_code)
      if item.nil?
        p 'Product not found'
      else
        @basket << item
      end
    end
  end

  def calculate_total
    @basket.each do |item|
      @subtotal += item[:price]
    end
    @subtotal
  end
end
