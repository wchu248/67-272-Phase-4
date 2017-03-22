require 'test_helper'

class ItemPriceTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:item)

  # test validations with matchers
  should validate_numericality_of(:price).is_greater_than_or_equal_to(0)
  should allow_value(Date.current).for(:start_date)
  should allow_value(1.day.ago.to_date).for(:start_date)
  should allow_value("wholesale").for(:category)
  should allow_value("manufacturer").for(:category)
  should_not allow_value(1.day.from_now.to_date).for(:start_date)
  should_not allow_value(123).for(:category)
  should_not allow_value("customer").for(:category)

  # set up context
  context "Within context" do
    setup do 
      create_pieces
      create_piece_prices
    end
    
    teardown do
      destroy_pieces
      destroy_piece_prices
    end

    should "check to make sure the end date is after the start date" do
      @bad_price = FactoryGirl.build(:item_price, item: @weighted_pieces, price: 5.95, start_date: 9.days.ago.to_date, end_date: 10.days.ago.to_date)
      deny @bad_price.valid?
    end 

    should "verify that the item is active in the system" do
      @bad_price = FactoryGirl.build(:item_price, item: @zagreb_pieces, price: 29.95)
      deny @bad_price.valid?
    end 

    should "verify that the old price end_date set to today" do
      assert_nil @wtp3.end_date
      @change_price = FactoryGirl.create(:item_price, item: @weighted_pieces, price: 9.95)
      @wtp3.reload
      assert_equal Date.current, @wtp3.end_date
    end

    should "have a working scope called current" do
      assert_equal [2.25, 2.50, 3.50, 4.50, 6.25, 7.50], ItemPrice.current.all.map(&:price).sort
    end

    should "have a working scope called chronological" do
      assert_equal [2.5, 4.5, 7.5, 2.25, 3.5, 6.25, 1.95, 2.95, 5.95], ItemPrice.chronological.all.map(&:price)
    end

    should "have a working scope called for_date" do
      assert_equal [1.95, 2.25, 2.95, 3.50, 5.95, 6.25], ItemPrice.for_date(9.months.ago.to_date).all.map(&:price).sort
    end

    should "have a working scope called for_item" do
      assert_equal [2.95, 3.5, 4.5], ItemPrice.for_item(@weighted_pieces.id).all.map(&:price).sort
    end

    should "have a working scope called wholesale" do
      assert_equal [2.95, 4.50], ItemPrice.for_item(@weighted_pieces.id).wholesale.all.map(&:price).sort
    end

    should "have a working scope called manufacturer" do
      assert_equal [2.25, 3.50, 6.25], ItemPrice.manufacturer.all.map(&:price).sort
    end

  end
end
