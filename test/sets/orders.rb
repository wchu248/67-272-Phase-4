module Contexts
  module Orders
    # Context for schools (assumes no prior contexts)

    def create_orders
      @simple_order = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu)
    end

    def destroy_orders
      @simple_order.delete
    end

  end
end