# frozen_string_literal: true

require './app/checkout'

RSpec.describe Checkout do
  subject(:checkout) { described_class.new }

  describe '#scan' do
    it 'can scan an item' do
      expect(checkout).to respond_to(:scan).with(1).argument
    end

    it 'can look up item and add it to basket' do
      expect { checkout.scan('FR1') }.not_to output(/Product not found/).to_stdout
      expect(checkout.basket).to eq([{ code: 'FR1', name: 'Fruit tea', price: 311 }])
    end

    it 'can look up multiple items and add to basket' do
      checkout.scan('FR1')
      checkout.scan('SR1')
      expect(checkout.basket).to eq([{ code: 'FR1', name: 'Fruit tea', price: 311 },
                                     { code: 'SR1', name: 'Strawberries', price: 500 }])
    end

    it 'can bulk scan a basket' do
      checkout.scan(%w[FR1 SR1 SR1])
      expect(checkout.basket).to eq([{ code: 'FR1', name: 'Fruit tea', price: 311 },
                                     { code: 'SR1', name: 'Strawberries', price: 500 }, { code: 'SR1', name: 'Strawberries', price: 500 }])
    end

    it 'prints message to console when item not in catalogue' do
      expect { checkout.scan('Foo') }.to output(/Product not found/).to_stdout
    end

    describe '#calculate_total' do
      it 'start with 0 total' do
        expect(checkout.calculate_total).to eq(0)
      end

      it 'calculates the correct total when no discounts apply' do
        checkout.scan(%w[FR1 SR1])
        expect(checkout.calculate_total).to eq(811)
      end

      context 'when bogof discount applies' do
        it 'calculates the correct total for single free item' do
          checkout.scan('FR1')
          checkout.scan('FR1')
          expect(checkout.calculate_total).to eq(311)
        end

        it 'calculates the correct total for multiple free item' do
          checkout.scan('FR1')
          checkout.scan('FR1')
          checkout.scan('FR1')
          checkout.scan('FR1')
          expect(checkout.calculate_total).to eq(622)
        end

        it 'calculates the correct total for incomplete offer' do
          checkout.scan('FR1')
          checkout.scan('FR1')
          checkout.scan('FR1')
          expect(checkout.calculate_total).to eq(622)
        end
      end
    end
  end
end
