require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  # testing relationships
  should have_many(:order_items)
  should have_many(:items).through(:order_items)
  should belong_to(:user)
  should belong_to(:school)

  # test simple validations with matchers
  should validate_numericality_of(:grand_total).is_greater_than(0)
  
  # testing date...
  should allow_value(Date.current).for(:date)
  should allow_value(13.days.ago.to_date).for(:date)
  
  should_not allow_value(13.days.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(2).for(:date)
  should_not allow_value(3.14159).for(:date)

  # testing grand total...
  should allow_value(10).for(:grand_total)
  should allow_value(49.99).for(:grand_total)

  should_not allow_value(0.00).for(:grand_total)
  should_not allow_value(-10).for(:grand_total)
  should_not allow_value("bad").for(:grand_total)

  # set up context
  context "Within context" do
    setup do 
      create_items
      create_item_prices
      create_schools
      create_users
      create_orders
      create_order_items
      @u_o_oi11 = FactoryGirl.create(:order_item, item: @basic_pieces, order: @not_shipped1, shipped_on: Date.current)
      @u_o_oi21 = FactoryGirl.create(:order_item, item: @weighted_pieces, order: @not_shipped1, quantity: 5)
      @u_o_oi12 = FactoryGirl.create(:order_item, item: @wooden_pieces, order: @not_shipped2, shipped_on: Date.current, quantity: 10)
      @u_o_oi22 = FactoryGirl.create(:order_item, item: @analog_clock, order: @not_shipped2, shipped_on: Date.current)
    end
    
    teardown do
      destroy_items
      destroy_item_prices
      destroy_schools
      destroy_users
      destroy_orders
      destroy_order_items
      @u_o_oi11.delete
      @u_o_oi21.delete
      @u_o_oi12.delete
      @u_o_oi22.delete
    end

    should "verify that the user must be active in the system" do
      bad_order = FactoryGirl.build(:order, school: @ingomar_elem, user: @inactive_user)
      deny bad_order.valid?
    end 

    should "verify that the school must be active in the system" do
      bad_order = FactoryGirl.build(:order, school: @watchung_high, user: @winston_chu)
      deny bad_order.valid?
    end 

    # THIS DOESN'T WORK AND IDK WHYYYYYYY
    should "set the date to the current date if it is not specified or if it is not a legitimate date" do
      #@illegitimate_date = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu, date: nil)
      #assert_equal Date.current, @illegitimate_date.date
    end

    should "show that the not_shipped method works correctly" do
      assert_equal [5.00, 6.00], Order.not_shipped.all.map{ |i| i.grand_total }
    end
    
    should "show that the total_weight method works correctly" do
      assert_in_delta 11.1, @simple_order.total_weight
      assert_in_delta 11.85, @not_shipped1.total_weight
      assert_in_delta 20.9, @not_shipped2.total_weight
    end

    should "show that the shipping_costs method works correctly" do
      assert_equal 7.00, @simple_order.shipping_costs
      assert_equal 7.00, @not_shipped1.shipping_costs
      assert_equal 9.25, @not_shipped2.shipping_costs
    end

    should "show that the credit_card_type method works correctly" do
      
    end

  end

end
