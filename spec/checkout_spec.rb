# frozen_string_literal: true

require './app/checkout'

RSpec.describe Checkout do
  subject(:checkout) { described_class.new(product_catalogue: product_catalogue, sales_rules: sales_rules) }

  let(:products) { File.read('./spec/fixtures/files/products/standard.json') }
  let(:offers) { File.read('./spec/fixtures/files/offers/standard.json') }
  let(:product_catalogue) { ProductCatalogue.new(products) }
  let(:sales_rules) { SalesRules.new(offers) }

  describe '#scan' do
    it 'can scan an item' do
      expect(checkout).to respond_to(:scan).with(1).argument
    end

    it 'can look up item and add it to basket' do
      expect { checkout.scan(:FR1) }.not_to output(/Product not found/).to_stdout
      expect(checkout.basket).to eq([{ code: 'FR1', name: 'Fruit tea', price: 311 }])
    end

    it 'can look up multiple items and add to basket' do
      checkout.scan(:FR1)
      checkout.scan(:SR1)
      expect(checkout.basket).to eq([{ code: 'FR1', name: 'Fruit tea', price: 311 },
                                     { code: 'SR1', name: 'Strawberries', price: 500 }])
    end

    it 'can bulk scan a basket' do
      checkout.scan(%i[FR1 CF1 CF1])
      expect(checkout.basket).to eq([{ code: 'FR1', name: 'Fruit tea', price: 311 },
                                     { code: 'CF1', name: 'Coffee', price: 1123 },
                                     { code: 'CF1', name: 'Coffee', price: 1123 }])
    end

    it 'prints message to console when item not in catalogue' do
      expect { checkout.scan(:FOO) }.to output(/Product not found/).to_stdout
    end
  end

  describe '#calculate_total' do
    it 'start with 0 total' do
      expect(checkout.calculate_total).to eq(0)
    end

    it 'calculates the correct total when no discounts apply' do
      checkout.scan(:FR1)
      checkout.scan(:SR1)
      expect(checkout.calculate_total).to eq(811)
    end

    context 'when bogof discount applies' do
      it 'calculates the correct total for single free item' do
        checkout.scan(%i[FR1 FR1])
        expect(checkout.calculate_total).to eq(311)
      end

      it 'calculates the correct total for multiple free item' do
        checkout.scan(%i[FR1 FR1 FR1 FR1])
        expect(checkout.calculate_total).to eq(622)
      end

      it 'calculates the correct total for incomplete offer' do
        checkout.scan(%i[FR1 FR1 FR1])
        expect(checkout.calculate_total).to eq(622)
      end
    end

    context 'when bulk offer applies' do
      it 'calculates the correct total when offer condition met' do
        checkout.scan(%i[SR1 SR1 SR1])
        expect(checkout.calculate_total).to eq(1350)
      end
    end

    context 'when basket is mixed and has multiple offer conditions met' do
      it 'calculates the correct total when offer condition met' do
        checkout.scan(%i[SR1 FR1 CF1 SR1 CF1 FR1 FR1 SR1])
        expect(checkout.calculate_total).to eq(4218)
      end
    end
  end
end
