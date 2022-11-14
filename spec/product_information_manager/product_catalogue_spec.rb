# frozen_string_literal: true

require './app/product_information_manager/product_catalogue'

RSpec.describe ProductCatalogue do
  let(:products) { File.read('./spec/fixtures/files/products/standard.json') }

  subject(:product_catalogue) { described_class.new(products) }

  describe '#fetch_item' do
    it 'can return an item that is in the catalogue' do
      expect(product_catalogue.fetch_item(:FR1)).to eq({ "code": 'FR1', "name": 'Fruit tea', "price": 311 })
    end

    it 'returns nil when item is not in catalogue' do
      expect(product_catalogue.fetch_item(:FOO)).to eq(nil)
    end
  end
end
