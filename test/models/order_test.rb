require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  # testing relationships
  should have_many(:order_items)
  should have_many(:items).through(:order_items)
  should belong_to(:user)
  should belong_to(:school)

  # test simple validations with matchers
  should validate_numericality_of(:grand_total).is_greater_than(0)

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
      @u_o_oi13 = FactoryGirl.create(:order_item, item: @chess_bag_green, order: @none_shipped, quantity: 4)
      @u_o_oi23 = FactoryGirl.create(:order_item, item: @chess_bag_brown, order: @none_shipped)
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
      @u_o_oi13.delete
      @u_o_oi23.delete
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
      @illegitimate_date1 = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu, date: nil)
      assert_equal Date.current, @illegitimate_date1.date
      @illegitimate_date2 = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu, date: "hello")
      assert_equal Date.current, @illegitimate_date2.date
    end

    should "show that the not_shipped method works correctly" do
      assert_equal [5.00, 6.00, 8.00], Order.not_shipped.all.map{|o| o.grand_total}
    end
    
    should "show that the total_weight method works correctly" do
      assert_in_delta 11.1, @simple_order.total_weight
      assert_in_delta 11.85, @not_shipped1.total_weight
      assert_in_delta 20.9, @not_shipped2.total_weight
      assert_in_delta 1.5, @none_shipped.total_weight
    end

    should "show that the shipping_costs method works correctly" do
      assert_equal 7.00, @simple_order.shipping_costs
      assert_equal 7.00, @not_shipped1.shipping_costs
      assert_equal 9.25, @not_shipped2.shipping_costs
      assert_equal 5.00, @none_shipped.shipping_costs
    end

    should "show that the credit_card_type method works correctly" do
      # testing N/A result
      @simple_order.credit_card_number = nil
      assert_equal "N/A", @simple_order.credit_card_type
      @simple_order.credit_card_number = 123081271827519
      assert_equal "N/A", @simple_order.credit_card_type
      # testing VISA cards
      @simple_order.credit_card_number = 4123456789012
      assert_equal "VISA", @simple_order.credit_card_type
      @simple_order.credit_card_number = 4123456789012345
      assert_equal "VISA", @simple_order.credit_card_type
      # testing MC cards
      @simple_order.credit_card_number = 5123456789012345
      assert_equal "MC", @simple_order.credit_card_type
      @simple_order.credit_card_number = 5423456789012345
      assert_equal "MC", @simple_order.credit_card_type
      # testing DISC cards
      @simple_order.credit_card_number = 6512345678901234
      assert_equal "DISC", @simple_order.credit_card_type     
      @simple_order.credit_card_number = 6011123456789012
      assert_equal "DISC", @simple_order.credit_card_type      
      # testing DCCB cards
      @simple_order.credit_card_number = 30012345678901
      assert_equal "DCCB", @simple_order.credit_card_type    
      @simple_order.credit_card_number = 30312345678901
      assert_equal "DCCB", @simple_order.credit_card_type      
      # testing AMEX cards
      @simple_order.credit_card_number = 341234567890123
      assert_equal "AMEX", @simple_order.credit_card_type
      @simple_order.credit_card_number = 371234567890123
      assert_equal "AMEX", @simple_order.credit_card_type
    end

    # testing getter and setter methods
    should "show that the order model can accept the credit card info as properties of an order" do
      assert @simple_order.respond_to?(:credit_card_number)
      assert @simple_order.respond_to?(:credit_card_number=)
      assert @simple_order.respond_to?(:expiration_year)
      assert @simple_order.respond_to?(:expiration_year=)
      assert @simple_order.respond_to?(:expiration_month)
      assert @simple_order.respond_to?(:expiration_month=)
    end

    should "show that invalid credit card numbers and expired cards cannot be accepted" do
      # if the number is invalid
      @bad_number = FactoryGirl.build(:order, school: @ingomar_elem, user: @winston_chu, credit_card_number: 12345, expiration_year: Date.current.year + 1, expiration_month: 1)
      deny @bad_number.valid?
      # with a valid number...
      # if the year is past...
      @expired_card1 = FactoryGirl.build(:order, school: @ingomar_elem, user: @winston_chu, credit_card_number: 30012345678901, expiration_year: Date.current.year - 1, expiration_month: 1)
      deny @expired_card1.valid?
      # if the year is the same but the month is past...
      @expired_card2 = FactoryGirl.build(:order, school: @ingomar_elem, user: @winston_chu, credit_card_number: 30012345678901, expiration_year: Date.current.year, expiration_month: Date.current.month == 1 ? 12 : Date.current.month - 1)
      deny @expired_card2.valid?
      # if the year is the same but the month is the current month...
      @not_expired = FactoryGirl.build(:order, school: @ingomar_elem, user: @winston_chu, credit_card_number: 30012345678901, expiration_year: Date.current.year, expiration_month: Date.current.month)
      assert @not_expired.valid?
      # with an invalid number and an expired date
      @really_bad_card = FactoryGirl.build(:order, school: @ingomar_elem, user: @winston_chu, credit_card_number: 12345, expiration_year: Date.current.year - 1, expiration_month: 1)
      deny @really_bad_card.valid?
    end

    should "show that the pay method works correctly" do
      assert_nil @simple_order.payment_receipt
      @simple_order.pay
      @simple_order.reload
      assert_not_nil @simple_order.payment_receipt
      assert_equal "order: #{@simple_order.id}; amount_paid: #{@simple_order.grand_total}; received: #{@simple_order.date}; card: #{@simple_order.credit_card_type} ****#{@simple_order.credit_card_number.to_s[-4..-1]}", Base64.decode64(@simple_order.payment_receipt)
      # making sure double payments cannot happen
      assert_equal false, @simple_order.pay
    end

    should "show that orders with no shipped items can be destroyed" do
      assert @none_shipped.destroy
      # make sure the associated order items are gone as well
      deny OrderItem.exists?(@u_o_oi13.id)
      deny OrderItem.exists?(@u_o_oi23.id)
      # try to destroy an order that can't be destroyed
      deny @not_shipped1.destroy
      # make sure order and shipped order items are still in system
      assert Order.exists?(@not_shipped1.id)
      assert OrderItem.exists?(@u_o_oi11.id)
      # make sure the unshipped order items are removed/cancelled
      deny OrderItem.exists?(@u_o_oi21.id)
    end

    should "show that the chronological scope works properly" do
      assert_equal [5.00, 6.00, 7.00, 8.00], Order.chronological.all.map{|o| o.grand_total}
    end

    should "show that the paid scope works properly" do
      assert_equal [6.00, 8.00], Order.paid.all.map{|o| o.grand_total}
    end

    should "show that the for_school scope works properly" do
      assert_equal [5.00], Order.for_school(@ingomar_elem.id).all.map{|o| o.grand_total}
      assert_equal [6.00, 8.00], Order.for_school(@central_school1.id).all.map{|o| o.grand_total}
      assert_equal [7.00], Order.for_school(@warren_middle.id).all.map{|o| o.grand_total}
      assert_equal [], Order.for_school(@central_school3.id).all.map{|o| o.grand_total}
    end

  end

end
