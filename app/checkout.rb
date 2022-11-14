# frozen_string_literal: true

require './app/product_information_manager/product_catalogue'
require './app/sales_rules'
require 'json'
require 'pry'
class Checkout
  attr_reader :basket

  def initialize(
    product_catalogue: ProductCatalogue.new(
      File.read('./spec/fixtures/files/products/standard.json')
    ),
    sales_rules: SalesRules.new(
      File.read('./spec/fixtures/files/offers/standard.json')
    )
  )
    @product_catalogue = product_catalogue
    @sales_rules = sales_rules
    @basket = []
    @subtotal = 0
    @total = 0
  end

  def scan(item_codes)
    item_codes.is_a?(Symbol) ? item_codes = [item_codes] : item_codes
    item_codes.each do |item_code|
      item = @product_catalogue.fetch_item(item_code)
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
    @discounts = @sales_rules.calculate_discounts(@basket)
  end
end
