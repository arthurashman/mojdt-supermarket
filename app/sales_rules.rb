# frozen_string_literal: true

class SalesRules
  OFFERS = [
    { name: 'bogof', item_code: 'FR1', buy: 2, free: 1 },
    { name: 'bulk', item_code: 'SR1', buy: 3, price_reduction: 50 }
  ].freeze

  def self.calculate_discounts(basket)
    discount = 0
    OFFERS.each do |offer|
      if offer[:name] == 'bogof' && basket.any? { |item| item.value?(offer[:item_code]) }
        discount += bogof(basket, offer)
      end
    end
    discount
  end

  def self.bogof(basket, offer)
    discount = 0
    eligible_items = basket.select { |item| item[:code] == offer[:item_code] }
    number_of_eligible_items = eligible_items.count
    if number_of_eligible_items >= offer[:buy]
      discount += number_of_eligible_items / offer[:buy] * (eligible_items[0][:price] * offer[:free])
    end
    discount
  end
end
