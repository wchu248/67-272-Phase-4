module Contexts
  module ItemPrices
    # Context for item_prices (assumes items context)
    def create_item_prices
      create_board_prices
      create_piece_prices
      create_clock_prices
      create_supply_prices
    end

    def destroy_item_prices
      destroy_board_prices
      destroy_piece_prices
      destroy_clock_prices
      destroy_supply_prices
    end

    def create_board_prices
      @vbg1 = FactoryGirl.create(:item_price, item: @vinyl_green, price: 1.85, start_date: 24.months.ago.to_date)
      @vbg2 = FactoryGirl.create(:item_price, item: @vinyl_green, price: 2.15, start_date: 14.months.ago.to_date)
      @vbg3 = FactoryGirl.create(:item_price, item: @vinyl_green, price: 2.50, start_date: 6.months.ago.to_date)
      @vbg4 = FactoryGirl.create(:item_price, item: @vinyl_green, price: 2.75, start_date: 4.weeks.ago.to_date)
           
      @vbb1 = FactoryGirl.create(:item_price, item: @vinyl_blue, price: 2.05, start_date: 24.months.ago.to_date)
      @vbb2 = FactoryGirl.create(:item_price, item: @vinyl_blue, price: 2.35, start_date: 14.months.ago.to_date)
      @vbb3 = FactoryGirl.create(:item_price, item: @vinyl_blue, price: 2.95, start_date: 6.months.ago.to_date)
      @vbb4 = FactoryGirl.create(:item_price, item: @vinyl_blue, price: 3.10, start_date: 4.weeks.ago.to_date)
           
      @vbr1 = FactoryGirl.create(:item_price, item: @vinyl_red, price: 2.05, start_date: 24.months.ago.to_date)
      @vbr2 = FactoryGirl.create(:item_price, item: @vinyl_red, price: 2.35, start_date: 14.months.ago.to_date)
      @vbr3 = FactoryGirl.create(:item_price, item: @vinyl_red, price: 2.95, start_date: 6.months.ago.to_date)
      @vbr4 = FactoryGirl.create(:item_price, item: @vinyl_red, price: 3.10, start_date: 4.weeks.ago.to_date)
           
      @vbk1 = FactoryGirl.create(:item_price, item: @vinyl_black, price: 1.85, start_date: 24.months.ago.to_date)
      @vbk2 = FactoryGirl.create(:item_price, item: @vinyl_black, price: 2.15, start_date: 14.months.ago.to_date)
      @vbk3 = FactoryGirl.create(:item_price, item: @vinyl_black, price: 2.50, start_date: 6.months.ago.to_date)
      @vbk4 = FactoryGirl.create(:item_price, item: @vinyl_black, price: 2.75, start_date: 4.weeks.ago.to_date)
           
      @mgh1 = FactoryGirl.create(:item_price, item: @mahogany_board, price: 23.00, start_date: 24.months.ago.to_date)
      @mgh2 = FactoryGirl.create(:item_price, item: @mahogany_board, price: 25.95, start_date: 13.months.ago.to_date)
      @mgh3 = FactoryGirl.create(:item_price, item: @mahogany_board, price: 29.00, start_date: 180.days.ago.to_date)
           
      @map1 = FactoryGirl.create(:item_price, item: @maple_board, price: 39.95, start_date: 12.months.ago.to_date)
      @map2 = FactoryGirl.create(:item_price, item: @maple_board, price: 42.00, start_date: 6.months.ago.to_date)
      @map3 = FactoryGirl.create(:item_price, item: @maple_board, price: 44.95, start_date: 2.weeks.ago.to_date)
    end

    def create_piece_prices
      @bcp1 = FactoryGirl.create(:item_price, item: @basic_pieces, price: 1.95, start_date: 24.months.ago.to_date)
      @bcp2 = FactoryGirl.create(:item_price, item: @basic_pieces, price: 2.25, start_date: 12.months.ago.to_date)
      @bcp3 = FactoryGirl.create(:item_price, item: @basic_pieces, price: 2.50, start_date: 6.months.ago.to_date)
           
      @wtp1 = FactoryGirl.create(:item_price, item: @weighted_pieces, price: 2.95, start_date: 24.months.ago.to_date)
      @wtp2 = FactoryGirl.create(:item_price, item: @weighted_pieces, price: 3.50, start_date: 12.months.ago.to_date)
      @wtp3 = FactoryGirl.create(:item_price, item: @weighted_pieces, price: 4.50, start_date: 6.months.ago.to_date)
           
      @wdp1 = FactoryGirl.create(:item_price, item: @wooden_pieces, price: 5.95, start_date: 24.months.ago.to_date)
      @wdp2 = FactoryGirl.create(:item_price, item: @wooden_pieces, price: 6.25, start_date: 12.months.ago.to_date)
      @wdp3 = FactoryGirl.create(:item_price, item: @wooden_pieces, price: 7.50, start_date: 6.months.ago.to_date)
    end

    def create_clock_prices
      @ana1 = FactoryGirl.create(:item_price, item: @analog_clock, price: 10.95, start_date: 24.months.ago.to_date)
      @zcr1 = FactoryGirl.create(:item_price, item: @zmf_red_clock, price: 21.95, start_date: 24.months.ago.to_date)
      @zcg1 = FactoryGirl.create(:item_price, item: @zmf_green_clock, price: 19.95, start_date: 24.months.ago.to_date)
      @chc1 = FactoryGirl.create(:item_price, item: @chronos_clock, price: 60.00, start_date: 24.months.ago.to_date)
    end

    def create_supply_prices
      @cbg1 = FactoryGirl.create(:item_price, item: @chess_bag_green, price: 6.95, start_date: 24.months.ago.to_date)
      @cbb1 = FactoryGirl.create(:item_price, item: @chess_bag_brown, price: 6.95, start_date: 24.months.ago.to_date)
      @dem1 = FactoryGirl.create(:item_price, item: @demo_board, price: 19.95, start_date: 24.months.ago.to_date)
      @sbk1 = FactoryGirl.create(:item_price, item: @scorebook, price: 1.50, start_date: 24.months.ago.to_date)
    end

    def destroy_board_prices
      @vbg1.delete
      @vbg2.delete
      @vbg3.delete
      @vbg4.delete
      @vbb1.delete
      @vbb2.delete
      @vbb3.delete
      @vbb4.delete
      @vbr1.delete
      @vbr2.delete
      @vbr3.delete
      @vbr4.delete
      @vbk1.delete
      @vbk2.delete
      @vbk3.delete
      @vbk4.delete
      @mgh1.delete
      @mgh2.delete
      @mgh3.delete
      @map1.delete
      @map2.delete
      @map3.delete
    end

    def destroy_piece_prices
      @bcp1.delete
      @bcp2.delete
      @bcp3.delete
      @wtp1.delete
      @wtp2.delete
      @wtp3.delete
      @wdp1.delete
      @wdp2.delete
      @wdp3.delete
    end

    def destroy_clock_prices
      @ana1.delete
      @zcr1.delete
      @zcg1.delete
      @chc1.delete
    end

    def destroy_supply_prices
      @cbg1.delete
      @cbb1.delete
      @dem1.delete
      @sbk1.delete
    end
  end
end