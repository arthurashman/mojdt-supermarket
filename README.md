# Supermarket

## Description
This project is a coding challenge set by MoJ D&T in November 2022 for a practical assessment component of the Senior Developer interview.

## Task
```
In our quest to stay in touch with what's going on in the commercial world we've
decided to open a supermarket - we sell only three products:


| Product code |     Name     |  Price  |
|--------------|--------------|---------|
|      FR1     |   Fruit tea  |    £3.11|
|      SR1     | Strawberries |    £5.00|
|      CF1     |    Coffee    |   £11.23|


Our CEO is a big fan of buy-one-get-one-free offers. She wants us to add a rule to
apply this rule to fruit tea.
The COO, though, likes low prices and wants people buying strawberries to get a
price discount for bulk purchases. If you buy 3 or more strawberries, the price should
drop to £4.50 each.
Our checkout can scan items in any order.
The CEO and COO change their minds often, so ideally this should be a flexible
solution (if you have time). For example, we might want to apply the offers to
different products, or add products to our range, as the supermarket grows.
Task
Your goal is to implement a checkout that scans items in and calculates total prices
correctly for any combination of the products and offers above.
```

## Getting Started

Clone the repository, and follow these steps in order.  
The instructions assume you have [Homebrew](https://brew.sh) installed in your machine, as well as use some ruby version manager, usually [rbenv](https://github.com/rbenv/rbenv). If not, please install all this first. Ensure you are using the ruby version specified in '.ruby-version'.

**Pre-requirements**
* `brew bundle`
* `gem install bundler`
* `bundle install`

**Load Checkout in IRB**
* `irb`
* `require './app/checkout.rb'`

## Usage

```irb
co = Checkout.new
co.scan([:FR1,:FR1,:SR1,:SR1,:SR1])
co.calculate_total
```

To aid flexibility and reuse, this checkout takes 2 parameters; a product catalogue and a sales rules object. They are defaulted to the products and offers as specified in the task, but either can be passed in by instantiating them along with json representations of new products or offers respectively:

```irb
pc = ProductCatalogue.new('{"AP1": { "code": "AP1", "name": "Apple", "price": 50}}')
sr = SalesRules.new('[{"name": "bulk", "item_code": "AP1", "basket_count": 4,"price_reduction": 10}]')
co = Checkout.new(product_catalogue: pc, sales_rules: sr)
co.scan([:AP1,:AP1,:AP1,:AP1])
co.calculate_total
```

## Tests
```
rspec
```

## Approach
Having read the task, I took a domain first approach (DDD), pencilling out the different objects as I considered them in the domain of a supermarket. 

 * Products would know their code 
 * Checkout would be able to manage a basket and calculate the basic cost of that basket
 * Product Catalogue would hold information about the products in the store (as the name and price could change over time or geographical location if the supermarket scaled)
 * Sales Rules would know what offers were available and how to apply them. In future this could also handle different types of rules (price reductions, flash sales) and process information on geographical location and duration of sale.

I then took to developing user stories, drawn from the requirements of the CEO and COO. Using these stories, I took a Test Driven (TDD) approach to fleshing out the functionality, refactoring where necessary to ensure each part of the system retained its focus on a single responsibility. 
With further future focus on flexibility, expansion and evolution of the system, I ensured that this solution offered a way to both take in an process different product lists, and offers. 

## Assumtions
I made a few assumtions in structuring this project.
1. That the intent was to keep the project small and local. Given the complexity of a real life implementation of this system, I would opt for a further separated architecture with management interfaces for each part, calling an API to fetch products and offers that are set centrally.
2. That there was no need to respond to the user with particular messaging, showing running totals or when discounts had been applied or offers had been part fulfilled.
3. That users would scan products that had product codes as symbols. Given more time I would implement type checking to ensure the system could handle erroneous products.

## Areas to develop
Areas which I would continue to develop given more time would be:
1. Error handling - for scanning of products that are not handled by the system
2. A receipt formatter and printer, which would take in data on products and offers applied and display an itemised receipt to the user
3. It would be interesting to include messaging to the user should they only part fulfil an offer
4. I was also interested in developing a front end interface to allow for a smoother user experience