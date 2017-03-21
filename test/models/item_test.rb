require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test relationships
  should have_many(:item_prices)
  should have_many(:purchases)

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

    should "return correct current price" do
      create_piece_prices
      assert_equal 2.50, @basic_pieces.current_price
      assert_equal 4.50, @weighted_pieces.current_price
      destroy_piece_prices
    end

    should "return correct price for past date" do
      create_piece_prices
      assert_equal 2.25, @basic_pieces.price_on_date(8.months.ago.to_date)
      assert_equal 3.50, @weighted_pieces.price_on_date(8.months.ago.to_date)
      destroy_piece_prices
    end

    should "return nil for current or past price if not set" do
      create_piece_prices
      assert_nil @zagreb_pieces.current_price
      assert_nil @basic_pieces.price_on_date(36.months.ago.to_date)
      destroy_piece_prices      
    end
  end
end
