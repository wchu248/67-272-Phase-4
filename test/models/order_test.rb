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
      create_boards
      create_board_prices
      create_schools
      create_users
      create_orders
      create_order_items
    end
    
    teardown do
      destroy_order_items
      destroy_orders
      destroy_users
      destroy_schools
      destroy_board_prices
      destroy_boards
    end

    should "verify that the user must be active in the system" do
      #bad_order = FactoryGirl.build(:order, school: @ingomar_elem, user: @inactive_user)
      #deny bad_order.valid?
    end 

    should "verify that the school must be active in the system" do
      #bad_order = FactoryGirl.build(:order, school: @watchung_high, user: @winston_chu)
      #deny bad_order.valid?
    end 

  end

end
