module Contexts
  module Orders
    # Context for schools (assumes no prior contexts)

    def create_orders
      @simple_order = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu)
      @not_shipped1 = FactoryGirl.create(:order, school: @central_school1, user: @allie_caron, grand_total: 6.00)
      @not_shipped2 = FactoryGirl.create(:order, school: @warren_middle, user: @jack_lance, grand_total: 7.00)
    end

    def destroy_orders
      @simple_order.delete
      @not_shipped1.delete
      @not_shipped2.delete
    end

  end
end