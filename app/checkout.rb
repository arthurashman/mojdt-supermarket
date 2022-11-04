# frozen_string_literal: true

require './app/product_information_manager/product_catalogue'
require './app/sales_rules'

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
    calculate_subtotal
    apply_discounts
    @total = @subtotal - @discounts
  end

  private

  def calculate_subtotal
    @basket.each do |item|
      @subtotal += item[:price]
    end
  end

  def apply_discounts
    @discounts = SalesRules.calculate_discounts(@basket)
  end
end
