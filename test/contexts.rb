# require needed files
require './test/sets/items'
require './test/sets/item_prices'
require './test/sets/purchases'
require './test/sets/schools'
require './test/sets/users'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::Items
  include Contexts::ItemPrices
  include Contexts::Purchases
  include Contexts::Schools
  include Contexts::Users
end