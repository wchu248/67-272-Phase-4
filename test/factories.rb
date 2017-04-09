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
    category "wholesale"
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

  factory :user do
    first_name "Winston"
    last_name "Chu"
    email "wchu27@gmail.com"
    phone "908-838-8767"
    username "wpchu"
    password "secret"
    password_confirmation "secret"
    role "admin"
    active true
  end

  factory :order_item do
    association :item
    association :order
    quantity 1
    shipped_on nil
  end
  
  factory :order do
    association :school
    association :user
    date Date.current
    grand_total 5.00
    payment_receipt nil
  end

end