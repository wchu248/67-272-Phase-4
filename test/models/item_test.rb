require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:item_prices)
  should have_many(:purchases)
  should have_many(:order_items)
  should have_many(:orders).through(:order_items)

  # test validations with matchers
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive
  should validate_numericality_of(:weight).is_greater_than(0)
  should validate_numericality_of(:inventory_level).only_integer.is_greater_than_or_equal_to(0)
  should validate_numericality_of(:reorder_level).only_integer.is_greater_than_or_equal_to(0)
  should validate_inclusion_of(:category).in_array(Item::CATEGORIES.to_h.values)

  # not necessary, but don't hurt...
  should allow_value(10).for(:weight)
  should allow_value(10.5).for(:weight)
  should allow_value(25).for(:inventory_level)
  should allow_value(20).for(:reorder_level)
  should allow_value(0).for(:inventory_level)
  should allow_value(0).for(:reorder_level)

  should_not allow_value(-10).for(:inventory_level)
  should_not allow_value(10.5).for(:inventory_level)
  should_not allow_value(-10).for(:reorder_level)
  should_not allow_value(10.5).for(:reorder_level)
  should_not allow_value(-1).for(:weight)
  should_not allow_value(0).for(:weight)

  # set up context
  context "Within context" do
    setup do 
      create_pieces
    end
    
    teardown do
      destroy_pieces
    end

    should "show that there are four items in in alphabetical order" do
      assert_equal ["Basic Chess Pieces", "Weighted Chess Pieces", "Wooden Chess Pieces", "Zagreb Chess Pieces"], Item.alphabetical.all.map(&:name)
    end

    should "show that there are three active items and one inactive item" do
      assert_equal ["Basic Chess Pieces", "Weighted Chess Pieces", "Wooden Chess Pieces"], Item.active.all.map(&:name).sort
      assert_equal ["Zagreb Chess Pieces"], Item.inactive.all.map(&:name).sort
    end

    should "show that there is a working for_category scope" do
      create_clocks
      assert_equal ["Basic Chess Pieces", "Weighted Chess Pieces", "Wooden Chess Pieces", "Zagreb Chess Pieces"], Item.for_category('pieces').all.map(&:name).sort
      assert_equal 4, Item.for_category('clocks').all.count
      destroy_clocks
    end

    should "show that there is a working for_color scope" do
      create_clocks
      assert_equal ["Basic Analog Chess Clock", "Basic Chess Pieces", "Weighted Chess Pieces", "ZMF-II Digital Chess Timer Green"], Item.for_color('black').all.map(&:name).sort
      assert_equal 1, Item.for_color('red').all.count
      destroy_clocks
    end

    should "show that there is a working need_reorder scope" do
      assert_equal 0, Item.need_reorder.all.count
      @weighted_pieces.inventory_level = 20 # factories set reorder_level at 25
      @weighted_pieces.save
      assert_equal ["Weighted Chess Pieces"], Item.need_reorder.all.map(&:name).sort
    end

    should "have an instance method reorder? for items where inventory too low" do
      deny @basic_pieces.reorder?
      deny @weighted_pieces.reorder?
      @weighted_pieces.inventory_level = 20
      @weighted_pieces.save
      assert @weighted_pieces.reorder?
    end

    should "return correct current wholesale price" do
      create_piece_prices
      assert_equal 2.50, @basic_pieces.current_price
      assert_equal 4.50, @weighted_pieces.current_price
      destroy_piece_prices
    end

    should "return correct current manufacturer price" do
      create_piece_prices
      assert_equal 2.25, @basic_pieces.current_manufacturer_price
      assert_equal 3.50, @weighted_pieces.current_manufacturer_price
      destroy_piece_prices
    end

    should "return correct wholesale price for past date" do
      create_piece_prices
      assert_equal 1.95, @basic_pieces.price_on_date(8.months.ago.to_date)
      assert_equal 2.95, @weighted_pieces.price_on_date(8.months.ago.to_date)
      destroy_piece_prices
    end

    should "return correct manufacturer price for past date" do
      create_piece_prices
      assert_equal 2.25, @basic_pieces.manufacturer_price_on_date(8.months.ago.to_date)
      assert_equal 3.50, @weighted_pieces.manufacturer_price_on_date(8.months.ago.to_date)
      destroy_piece_prices
    end

    should "return nil for current or past price if not set" do
      create_piece_prices
      assert_nil @zagreb_pieces.current_price
      assert_nil @zagreb_pieces.current_manufacturer_price
      assert_nil @basic_pieces.price_on_date(36.months.ago.to_date)
      assert_nil @basic_pieces.manufacturer_price_on_date(36.months.ago.to_date)
      destroy_piece_prices      
    end

    should "make sure that items that have never been shipped can be destroyed" do
      # creating the rest of the stuff for the context of this test
      create_boards
      create_clocks
      create_supplies
      create_item_prices
      create_schools
      create_users
      create_orders
      create_order_items
      # show that items that have never been shipped can be destroyed
      assert @vinyl_green.destroy
      assert @vinyl_blue.destroy
      # destroyed the rest of the stuff for the context of this test
      destroy_boards
      destroy_clocks
      destroy_supplies
      destroy_item_prices
      destroy_schools
      destroy_users
      destroy_orders
      destroy_order_items
    end

    should "make sure that items that have been shipped are made inactive and their respective order items are destroyed properly" do 
      # creating the rest of the stuff for the context of this test
      create_boards
      create_clocks
      create_supplies
      create_item_prices
      create_schools
      create_users
      create_orders
      create_order_items
      # show that items that have been shipped are originally active before trying to destroy
      assert_equal true, @vinyl_red.active
      assert_equal true, @mahogany_board.active
      assert_equal true, @maple_board.active
      # show that the order items for the items that have been shipped are originally in the system before trying to destroy
      assert OrderItem.exists?(@vrb_order.id)
      assert OrderItem.exists?(@mahogany_order.id)
      assert OrderItem.exists?(@maple_order.id)
      assert OrderItem.exists?(@unshipped_vrb_order.id)
      assert OrderItem.exists?(@unshipped_mahogany_order.id)
      assert OrderItem.exists?(@unshipped_maple_order.id)
      # check that certain order items are actually unshipped and unpaid
      assert_not_nil @vrb_order.shipped_on
      assert_not_nil @mahogany_order.shipped_on
      assert_not_nil @maple_order.shipped_on
      assert_nil @unshipped_vrb_order.order.payment_receipt
      assert_nil @unshipped_mahogany_order.order.payment_receipt
      assert_nil @unshipped_maple_order.order.payment_receipt
      assert_nil @unshipped_vrb_order.shipped_on
      assert_nil @unshipped_mahogany_order.shipped_on
      assert_nil @unshipped_maple_order.shipped_on
      # THEN TRY TO DESTROY THE ITEMS
      # show that items that have been shipped cannot be destroyed
      deny @vinyl_red.destroy
      deny @mahogany_board.destroy
      deny @maple_board.destroy
      # show that items that have been shipped are made inactive
      assert_equal false, @vinyl_red.active
      assert_equal false, @mahogany_board.active
      assert_equal false, @maple_board.active
      # show that any unshipped, unpaid order items for those items are removed and shipped order items still exist
      assert OrderItem.exists?(@vrb_order.id)
      assert OrderItem.exists?(@mahogany_order.id)
      assert OrderItem.exists?(@maple_order.id)
      deny OrderItem.exists?(@unshipped_vrb_order.id)
      deny OrderItem.exists?(@unshipped_mahogany_order.id)
      deny OrderItem.exists?(@unshipped_maple_order.id)
      # destroyed the rest of the stuff for the context of this test
      destroy_boards
      destroy_clocks
      destroy_supplies
      destroy_item_prices
      destroy_schools
      destroy_users
      destroy_orders
      destroy_order_items
    end

  end
end
