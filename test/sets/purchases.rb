module Contexts
  module Purchases
    # Context for purchase (assumes items context)
    def create_purchases
      @p_vboards  = FactoryGirl.create(:purchase, item: @vinyl_green, quantity: 50, date: 2.months.ago.to_date)
      @p_vboards2 = FactoryGirl.create(:purchase, item: @vinyl_green, quantity: 25, date: 2.weeks.ago.to_date)
      @p_bpieces  = FactoryGirl.create(:purchase, item: @basic_pieces, quantity: 100, date: 1.month.ago.to_date)
      @p_loss     = FactoryGirl.create(:purchase, item: @basic_pieces, quantity: -10, date: 1.week.ago.to_date)
      @p_clocks   = FactoryGirl.create(:purchase, item: @analog_clock, quantity: 30)
    end
    
    def destroy_purchases
      @p_vboards.delete
      @p_vboards2.delete
      @p_bpieces.delete
      @p_loss.delete
      @p_clocks.delete
    end

    # The following o be used for acceptance testing with cucumber (not unit or functional testing)
    def create_fixed_date_purchase
      @p_chronos = FactoryGirl.create(:purchase, item: @chronos_clock, quantity: 12, date: Date.new(2017,2,15))
    end

    def destroy_fixed_date_purchase
      @p_chronos.delete
    end

    def create_purchase_for_reorder_list_test
      @p_scorebook = FactoryGirl.create(:purchase, item: @scorebook, quantity: -80, date: Date.current)
    end

    def destroy_purchase_for_reorder_list_test
      @p_scorebook.delete
    end


  end
end