# frozen_string_literal: true

class SalesRules
  OFFERS = [
    { name: 'bogof', item_code: 'FR1', buy: 2, free: 1 },
    { name: 'bulk', item_code: 'SR1', buy: 3, price_reduction: 50 }
  ].freeze

  def self.calculate_discounts(basket)
    discount = 0
    OFFERS.each do |offer|
      discount += apply_discount(basket, offer) if basket.any? { |item| item.value?(offer[:item_code]) }
    end
    discount
  end

  def self.apply_discount(basket, offer)
    discount = 0
    eligible_items = basket.select { |item| item[:code] == offer[:item_code] }
    number_of_eligible_items = eligible_items.count

    if number_of_eligible_items >= offer[:buy]
      case offer[:name]
      when 'bogof'
        discount += number_of_eligible_items / offer[:buy] * (eligible_items[0][:price] * offer[:free])
      when 'bulk'
        discount += number_of_eligible_items * offer[:price_reduction]
      end
    end
    discount
  end
end
