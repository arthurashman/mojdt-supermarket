# frozen_string_literal: true

module ProductInformationManager
  class ProductCatalogue
    PRODUCTS = {
      'FR1': { code: 'FR1', name: 'Fruit tea', price: 311 },
      'SR1': { code: 'SR1', name: 'Strawberries', price: 500 },
      'CF1': { code: 'CF1', name: 'Coffee', price: 1123 }
    }.freeze

    def self.fetch_item(item_code)
      PRODUCTS[item_code.to_sym]
    end
  end
end
