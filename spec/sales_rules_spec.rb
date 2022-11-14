# frozen_string_literal: true

require './app/sales_rules'

RSpec.describe SalesRules do
  let(:offers) { File.read('./spec/fixtures/files/offers/standard.json') }

  subject(:sales_rules) { described_class.new(offers) }

  describe '#calculate_discounts' do
    it 'determines discounts on a basket of products when none apply' do
      expect(sales_rules.calculate_discounts([{ "code": 'FR1', "name": 'Fruit tea', "price": 311 }])).to eq(0)
    end

    it 'determines discounts on a mixed basket of products containing offers' do
      expect(sales_rules.calculate_discounts([
                                               { "code": 'CF1', "price": 1123 },
                                               { "code": 'FR1', "price": 311 },
                                               { "code": 'CF1', "price": 1123 },
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'FR1', "price": 311 },
                                               { "code": 'FR1', "price": 311 },
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'FOO', "price": 42 }
                                             ])).to eq(461)
    end
  end

  describe '#apply_discount' do
    it 'determines discounts on a basket of products for single bogof offer' do
      expect(sales_rules.calculate_discounts([
                                               { "code": 'FR1', "name": 'Fruit tea', "price": 311 },
                                               { "code": 'FR1', "name": 'Fruit tea', "price": 311 }
                                             ])).to eq(311)
    end

    it 'determines discounts on a basket of products for bulk offer' do
      expect(sales_rules.calculate_discounts([
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'SR1', "price": 500 }
                                             ])).to eq(150)
    end

    it 'determines discounts on a basket of products with both offers' do
      expect(sales_rules.calculate_discounts([
                                               { "code": 'FR1', "price": 311 },
                                               { "code": 'FR1', "price": 311 },
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'SR1', "price": 500 },
                                               { "code": 'SR1', "price": 500 }
                                             ])).to eq(461)
    end
  end
end
