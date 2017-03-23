module Contexts
  module OrderItems
    # Context for order items (assumes items and item prices context)
    # test this with board items (don't forget to call create_boards and destroy_boards)

    def create_order_items
      # create a simple order so order items can have association with
      @simple_order = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu)
      @vgb_order = FactoryGirl.create(:order_item, item: @vinyl_green, order: @simple_order)
      @vbb_order = FactoryGirl.create(:order_item, item: @vinyl_blue, order: @simple_order, quantity: 2)
      @vrb_order = FactoryGirl.create(:order_item, item: @vinyl_red, order: @simple_order, shipped_on: Date.current)
      @mahogany_order = FactoryGirl.create(:order_item, item: @mahogany_board, order: @simple_order, shipped_on: 3.weeks.ago.to_date)
      @maple_order = FactoryGirl.create(:order_item, item: @maple_board, order: @simple_order, shipped_on: 6.weeks.ago.to_date)
    end

    def destroy_order_items
      @maple_order.delete
      @mahogany_order.delete
      @vrb_order.delete
      @vbb_order.delete
      @vgb_order.delete
      @simple_order.delete
    end

  end
end