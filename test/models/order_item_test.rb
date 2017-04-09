require 'test_helper'

class OrderItemTest < ActiveSupport::TestCase

# need to finish order model for these to work

  # testing relationships
  should belong_to(:item)
  should belong_to(:order)    

  # testing validations
  should validate_presence_of(:order_id)
  should validate_presence_of(:item_id)
  should validate_presence_of(:quantity)

  # validating quantity
  should allow_value(1).for(:quantity)
  should allow_value(5).for(:quantity)

  should_not allow_value(0).for(:quantity)
  should_not allow_value(1.5).for(:quantity)
  should_not allow_value(-1).for(:quantity)
  should_not allow_value(-10).for(:quantity)
  should_not allow_value("bad").for(:quantity)
  should_not allow_value(Date.current).for(:quantity)

  # validating shipped_on
  should allow_value(Date.current).for(:shipped_on)
  should allow_value(4.days.ago.to_date).for(:shipped_on)

  should_not allow_value(4.days.from_now.to_date).for(:shipped_on)
  should_not allow_value(100.weeks.from_now.to_date).for(:shipped_on)
  should_not allow_value("bad").for(:shipped_on)
  should_not allow_value(0).for(:shipped_on)

  # testing other scopes/methods with a context
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
      destroy_schools
      destroy_users
      destroy_boards
      destroy_board_prices
      destroy_order_items
    end

    # testing shipped and unshipped scope
    should "show that there are three shipped order items and five unshipped order items" do
      assert_equal ["Vinyl Chess Board - Red & White", "Mahogany Wood Chess Board", "Maple Wood Chess Board"], OrderItem.shipped.all.map{|o| o.item.name}
      assert_equal ["Vinyl Chess Board - Green & White", "Vinyl Chess Board - Blue & White", "Vinyl Chess Board - Red & White", "Mahogany Wood Chess Board", "Maple Wood Chess Board"], OrderItem.unshipped.all.map{|o| o.item.name}
    end

    # test the custom validation 'item_is_active_in_system'
    should "identify a non-active item as inactive" do
      # try to build an order item for an inactive item
      @fakeOrderItem = FactoryGirl.build(:purchase, item: @rosewood_board)
      deny @fakeOrderItem.valid?
      @fakeOrderItem.destroy
    end

    # test the subtotal instance method
    should "show that the subtotal instance method returns the correct output" do
      assert_equal 2.75, @vgb_order.subtotal
      assert_equal 6.20, @vbb_order.subtotal
      assert_equal 2.50, @vgb_order.subtotal(1.month.ago.to_date)
      assert_nil @vgb_order.subtotal(3.days.from_now.to_date)
    end

    # test the shipped instance method
    should "show that the shipped instance method does the correct thing" do
      assert_nil @vgb_order.shipped_on
      assert_nil @vbb_order.shipped_on
      vgb_old_inv = @vgb_order.item.inventory_level
      vbb_old_inv = @vbb_order.item.inventory_level
      @vgb_order.shipped
      @vbb_order.shipped
      @vgb_order.reload
      @vbb_order.reload
      assert_equal Date.current, @vgb_order.shipped_on
      assert_equal Date.current, @vbb_order.shipped_on
      assert_equal @vgb_order.item.inventory_level, vgb_old_inv - @vgb_order.quantity
      assert_equal @vbb_order.item.inventory_level, vbb_old_inv - @vbb_order.quantity
    end

  end

end
