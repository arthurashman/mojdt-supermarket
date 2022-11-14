# frozen_string_literal: true

class ProductCatalogue
  def initialize(products)
    @products = JSON.parse(products, symbolize_names: true)
  end

  def fetch_item(item_code)
    @products[item_code]
  end
end
