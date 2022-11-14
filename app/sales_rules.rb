# frozen_string_literal: true

class SalesRules
  def initialize(offers)
    @offers = JSON.parse(offers, symbolize_names: true)
  end

  def calculate_discounts(basket)
    discount = 0
    @offers.each do |offer|
      discount += apply_discount(basket, offer) if basket.any? do |item|
        item.value?(offer[:item_code])
      end
    end
    discount
  end

  private

  def apply_discount(basket, offer)
    discount = 0
    eligible_items = basket.select { |item| item[:code] == offer[:item_code] }
    number_of_eligible_items = eligible_items.count

    if number_of_eligible_items >= offer[:basket_count]
      case offer[:name]
      when 'bogof'
        discount += number_of_eligible_items / offer[:basket_count] * (eligible_items[0][:price] * offer[:free])
      when 'bulk'
        discount += number_of_eligible_items * offer[:price_reduction]
      end
    end
    discount
  end
end
