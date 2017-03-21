FactoryGirl.define do
  factory :item do
    name "Vinyl Chess Board - Green & White"
    description "These Vinyl Chess Boards are just what their name implies - a good basic chess board which meets all tournament standards. Board measures 20x20 inches with 2.25 inch square and all boards have clear and legible algebraic notation."
    color "green/white"
    category "boards"
    weight 0.5
    inventory_level 100
    reorder_level 25
    active true
  end

  factory :item_price do
    association :item
    price 1.00
    start_date Date.current
    end_date nil
  end

  factory :purchase do
    association :item
    quantity 1
    date Date.current
  end

  factory :school do
    name "Ingomar Elementary"
    street_1 "10 Downing Street"
    street_2 "Suite #101"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    min_grade 1
    max_grade 5
    active true
  end

end