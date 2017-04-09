module Contexts
  module Orders
    # Context for schools (assumes no prior contexts)

    def create_orders
      @simple_order = FactoryGirl.create(:order, school: @ingomar_elem, user: @winston_chu, credit_card_number: 4123456789012, expiration_year: Date.current.year + 1, expiration_month: 12)
      @not_shipped1 = FactoryGirl.create(:order, school: @central_school1, user: @allie_caron, date: 1.day.ago.to_date, grand_total: 6.00, payment_receipt: "12848bdsfab iuwefh")
      @not_shipped2 = FactoryGirl.create(:order, school: @warren_middle, user: @jack_lance, date: 2.days.ago.to_date, grand_total: 7.00)
      @none_shipped = FactoryGirl.create(:order, school: @central_school1, user: @sean_anderson, date: 3.days.ago.to_date, grand_total: 8.00, payment_receipt: "awelfnao2do2asjfna w")
    end

    def destroy_orders
      @simple_order.delete
      @not_shipped1.delete
      @not_shipped2.delete
      @none_shipped.delete
    end

  end
end