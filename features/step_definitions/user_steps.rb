require './test/contexts'
include Contexts

Given /^an initial setup$/ do
  # context used for phase 3 only
  create_items
  create_purchases
  create_item_prices
end

Given /^no setup yet$/ do
  # assumes initial setup already run as background
  destroy_items
  destroy_purchases
  destroy_item_prices
end

Given /^only items$/ do
  # Items only, no prices or purchases
  create_items
end

Given /^a dated purchase$/ do
  # Assuming items are already created
  create_fixed_date_purchase
end

Given /^a large scorebook purchase$/ do
  # Assuming items are already created
  create_purchase_for_reorder_list_test
end