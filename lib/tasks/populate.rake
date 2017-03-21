namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Docs at: http://faker.rubyforge.org/rdoc/
    # require 'faker'
    require 'factory_girl_rails'
    
    # Step 0: drop old databases and rebuild
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke

    # Step 1: create pieces along with purchases and prices
    sizes = [2.25, 3, 3.5, 4]
    quantities = [10,20,25,30,40,50,100]
    price_increments = [0.15,0.15,0.2,0.2,0.25,0.25,0.3,0.4]
    basic_pieces_array = Array.new
    weighted_pieces_array = Array.new

    sizes.each do |size|
      basic_pieces = FactoryGirl.create(:item, 
        name: "Basic Chess Pieces - #{size} inch King", 
        description: "The Basic Chess Pieces are our least expensive pieces and are ideal for schools and clubs working on a tight budget. These chess sets meet all chess tournament standards and regulations. They are a standard Staunton design and have a 3 3/4 inch tall King with a 1 1/2 inch felt paper base.", 
        color: "black/white", 
        category: "pieces", 
        weight: 0.85)
      basic_pieces_array << basic_pieces

      weighted_pieces = FactoryGirl.create(:item, 
        name: "Weighted Chess Pieces - #{size} inch King", 
        description: "Our Weighted Tournament Chess Pieces are just that - heavy! The entire set weighs in at just over 2 pounds and has a nice weighted feel. The pieces are easy to play with and their weight makes them perfect for tournaments or blitz play. With a King of 3 3/4 inch tall and a 1 1/2 inch base, these pieces meet all tournament regulations. The set includes extra queens as well.", 
        color: "black/white", 
        category: "pieces", 
        weight: 2.2)
      weighted_pieces_array << weighted_pieces
    end

    basic_pieces_array.each do |bp|
      old_price = 1.65
      4.times do |i|
        price = old_price + price_increments.sample
        month = 24 - 6*i
        new_price = FactoryGirl.create(:item_price, item: bp, price: price, start_date: month.months.ago.to_date)
        old_price = new_price.price
        FactoryGirl.create(:purchase, item: bp, quantity: quantities.sample, date: month.months.ago.to_date)
      end
    end

    weighted_pieces_array.each do |wp|
      old_price = 2.65
      4.times do |i|
        price = old_price + price_increments.sample
        month = 23 - 6*i
        new_price = FactoryGirl.create(:item_price, item: wp, price: price, start_date: month.months.ago.to_date)
        old_price = new_price.price
        FactoryGirl.create(:purchase, item: wp, quantity: quantities.sample, date: month.months.ago.to_date)
      end
    end

    zagreb_pieces = FactoryGirl.create(:item, 
      name: "Zagreb Chess Pieces", 
      description: "This is a beautiful reproduction of Zagreb Chess Set used at major international chess tournaments. The queens and bishops have a contrasting color ball on top and the king has a contrasting crown. The knight is a most interesting piece. Patterned after a Russian knight, he has his head down, a closed mouth, a dramatically carved head, and thin curved neck above his thick chest.  As with all wood pieces, sets many have variations in colors of grain within a set.  These pieces are weighted.", 
      color: "brown/tan", 
      category: "pieces", 
      weight: 2.25,
      inventory_level: 25,
      reorder_level: 10,
      active: false)

    wooden_pieces = FactoryGirl.create(:item, 
      name: "Wooden Chess Pieces", 
      description: "These beautiful wooden chess pieces are a great addition to any chess pieces collection or entry-level wood chess sets. The pieces are specifically designed to offer a solid, durable style that can stand up to abuse without breaking. They are designed with a simple but traditional style and are available in two wood finishes for the dark pieces. Light pieces are made from light boxwood, and dark pieces are made from sheesham. Each set features a full 32 pieces. These pieces are lightly weighted.", 
      color: "brown/tan", 
      category: "pieces",
      inventory_level: 40,
      reorder_level: 10, 
      weight: 2.0)

    wdp1 = FactoryGirl.create(:item_price, item: wooden_pieces, price: 5.95, start_date: 24.months.ago.to_date)
    wdr1 = FactoryGirl.create(:purchase, item: wooden_pieces, quantity: quantities.sample, date: 24.months.ago.to_date)
    wdp2 = FactoryGirl.create(:item_price, item: wooden_pieces, price: 6.25, start_date: 12.months.ago.to_date)
    wdr1 = FactoryGirl.create(:purchase, item: wooden_pieces, quantity: quantities.sample, date: 12.months.ago.to_date)
    wdp3 = FactoryGirl.create(:item_price, item: wooden_pieces, price: 7.50, start_date: 6.months.ago.to_date)
    wdr1 = FactoryGirl.create(:purchase, item: wooden_pieces, quantity: quantities.sample, date: 6.months.ago.to_date)

    # Step 2: create boards along with purchases and prices
    colors = %w[green blue black red]
    vinyl_boards_array = Array.new

    colors.each do |color|
      vinyl_board = FactoryGirl.create(:item, 
        name: "Vinyl Chess Board - #{color.capitalize} & White", 
        color: "#{color}/white")
      vinyl_boards_array << vinyl_board
    end
    
    vinyl_boards_array.each do |vb|
      old_price = 1.55
      4.times do |j|
        price = old_price + price_increments.sample
        month = 24 - 6*j
        new_price = FactoryGirl.create(:item_price, item: vb, price: price, start_date: month.months.ago.to_date)
        old_price = new_price.price
        FactoryGirl.create(:purchase, item: vb, quantity: quantities.sample, date: month.months.ago.to_date)
      end
    end

    mahogany_board = FactoryGirl.create(:item, 
      name: "Mahogany Wood Chess Board", 
      description: "This attractive and affordable chess board features a classic 1-1/2 inch mahogany border. The squares are 2-1/8 inch and the board is 1/2 inch thick. It is made in Poland of quality manufacturing with alternating Mahogany squares.", 
      color: "brown/tan",
      weight: 2.1)
    mgh1 = FactoryGirl.create(:item_price, item: mahogany_board, price: 23.00, start_date: 24.months.ago.to_date)
    mgh2 = FactoryGirl.create(:item_price, item: mahogany_board, price: 25.95, start_date: 13.months.ago.to_date)
    mgh3 = FactoryGirl.create(:item_price, item: mahogany_board, price: 29.00, start_date: 180.days.ago.to_date)

    maple_board    = FactoryGirl.create(:item, 
      name: "Maple Wood Chess Board", 
      description: "This board is composed of alternating 2 1/4 inch maple and walnut squares. It has a beautiful, unique 2 inch maple border with walnut trim around the playing surface for the perfect contrast. It makes an elegant companion to chess pieces with a king base of 1 3/8 inch to 1 3/4 inch (3-3/4 inch king height).  The board is backed with felt so it will not scratch the surface where it sits. It will look great with pieces featuring light or natural wooden tones.", 
      color: "brown/tan",
      weight: 2.2)      
    map1 = FactoryGirl.create(:item_price, item: maple_board, price: 39.95, start_date: 12.months.ago.to_date)
    map2 = FactoryGirl.create(:item_price, item: maple_board, price: 42.00, start_date: 6.months.ago.to_date)
    map3 = FactoryGirl.create(:item_price, item: maple_board, price: 44.95, start_date: 2.weeks.ago.to_date)

    rosewood_board  = FactoryGirl.create(:item, 
      name: "Rosewood Chess Board", 
      description: "This beautiful wood chess board is made of maple and rosewood with a very distinct and luxurious grain. The board has a narrow black accent separating the border from the squares, and the rosewood border features a black beveled edge. It makes an outstanding board for chess pieces with a king height of 3 3/4 inches. The board is backed with felt so it will not scratch the surface where it sits.", 
      weight: 2.25,
      color: "brown/tan",
      active: false)

    # Step 3: create clocks and prices (no purchases)      
    analog_clock = FactoryGirl.create(:item, 
      name: "Basic Analog Chess Clock", 
      description: "This Basic Chess Clock is an easy to use analog clock in an attractive black plastic case. Just wind up the movement, set the hands and you are ready to go. This chess clock is ideal for schools & clubs or for anyone who wants the simplicity of an analog chess clock.", 
      color: "black", 
      category: "clocks", 
      weight: 0.9)

    zmf_red_clock = FactoryGirl.create(:item, 
      name: "ZMF-II Digital Chess Timer Red", 
      description: "The ZMF-II has modern, bright LED display technology, stainless steel, accurate, touch sense buttons, and a red durable plastic case made here in the USA. The ZMF-II has fewer features than the Chronos, but most everything you will need. Chronos has a metal case. ZMF-II is plastic. However at half the price you can buy two for the price of a Chronos.", 
      color: "red", 
      category: "clocks", 
      inventory_level: quantities.sample,
      weight: 1.0)

    zmf_green_clock = FactoryGirl.create(:item, 
      name: "ZMF-II Digital Chess Timer Green", 
      description: "The ZMF-II has modern, bright LED display technology, stainless steel, accurate, touch sense buttons, and durable plastic case made here in the USA. The ZMF-II has fewer features than the Chronos, but most everything you will need. Chronos has a metal case. ZMF-II is plastic. However at half the price you can buy two for the price of a Chronos.", 
      color: "green/black", 
      category: "clocks", 
      inventory_level: quantities.sample,
      weight: 1.0)

    chronos_clock = FactoryGirl.create(:item, 
      name: "Chronos Chess Clock", 
      description: "Our best chess clock, the Chronos Digital Chess Clock has two 2 LCD screens in a metal casing with touch sensors so that you don't push the button down; it just senses the slightest brush of your finger. It has 4 preset blitz times, 8 preset tournament controls, move counter, a new GO! time setting, and many other adjustments. It is also fully customizable and can have any delay or increment time as well--perfect for chess tournaments.", 
      color: "beige", 
      category: "clocks", 
      inventory_level: quantities.sample,
      weight: 1.2)
    ana1 = FactoryGirl.create(:item_price, item: analog_clock, price: 10.95, start_date: 24.months.ago.to_date)
    zcr1 = FactoryGirl.create(:item_price, item: zmf_red_clock, price: 21.95, start_date: 24.months.ago.to_date)
    zcg1 = FactoryGirl.create(:item_price, item: zmf_green_clock, price: 19.95, start_date: 24.months.ago.to_date)
    chc1 = FactoryGirl.create(:item_price, item: chronos_clock, price: 60.00, start_date: 24.months.ago.to_date)

    # Step 4: create supplies
    chess_bag_green = FactoryGirl.create(:item, 
      name: "Carry-All Tournament Chess Set Bag Green", 
      description: "The Carryall Tournament Chess Bags are the perfect answer for storing and carrying all of your chess equipment. Each 24 inch x 7 inch chess bag is made of durable nylon canvas and will hold a rolled-up chess board, a full set of chess pieces, and most chess clocks.", 
      color: "green", 
      category: "supplies", 
      inventory_level: quantities.sample,
      weight: 0.3)

    chess_bag_brown = FactoryGirl.create(:item, 
      name: "Carry-All Tournament Chess Set Bag Brown", 
      description: "The Carryall Tournament Chess Bags are the perfect answer for storing and carrying all of your chess equipment. Each 24 inch x 7 inch chess bag is made of durable nylon canvas and will hold a rolled-up chess board, a full set of chess pieces, and most chess clocks.", 
      color: "brown", 
      category: "supplies", 
      inventory_level: quantities.sample,
      weight: 0.3)

    demo_board = FactoryGirl.create(:item, 
      name: "Chess Demo Board and Pieces", 
      description: "Our Chess Demo Board with Clear Pieces & Bag is our most up-to-date, as well as our largest chess demo board. It is a huge 36 inch size with 4 inch squares so you can use this board to teach large groups of students easily.", 
      color: "green/white", 
      category: "supplies", 
      inventory_level: quantities.sample,
      weight: 2.0)

    scorebook = FactoryGirl.create(:item, 
      name: "Softcover Quality Scorebook", 
      description: "Each scorebook holds 50 chess games and is spiral bound for easy access to your games and so you won't lose them. They also have a cardstock cover and back page for durability and protection. Each page holds 100 moves per sheet and has a blank diagram for special or adjourned positions.", 
      color: "orange", 
      category: "supplies", 
      weight: 0.25)

    cbg1 = FactoryGirl.create(:item_price, item: chess_bag_green, price: 6.95, start_date: 24.months.ago.to_date)
    cbb1 = FactoryGirl.create(:item_price, item: chess_bag_brown, price: 6.95, start_date: 24.months.ago.to_date)
    dem1 = FactoryGirl.create(:item_price, item: demo_board, price: 19.95, start_date: 24.months.ago.to_date)
    sbk1 = FactoryGirl.create(:item_price, item: scorebook, price: 1.50, start_date: 24.months.ago.to_date)
    p_scorebook = FactoryGirl.create(:purchase, item: scorebook, quantity: -80, date: Date.yesterday)

  end
end