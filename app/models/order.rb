class Order < ActiveRecord::Base

  # Relationships
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :user
  belongs_to :school

  # Scopes
  # orders results chronologically with most recent orders at the top of the list
  scope :chronological, -> { order(date: :desc) }
  # returns all orders that have a payment receipt
  scope :paid,          -> { where.not(payment_receipt: nil) }
  # returns all orders for a specified school
  scope :for_customer,  ->(school_id) { where(school_id: school_id) }

  # Validations
  validates_date :date, on_or_before: lambda { Date.current }
  # make sure grand_total is a valid number
  validates_numericality_of :grand_total, greater_than_or_equal_to: 0, allow_blank: true
  # make sure required fields are present
  validates_presence_of :school_id, :user_id, :date
  validate :user_is_active_in_system
  validate :school_is_active_in_system

  # Callbacks
  before_save :calculate_grand_total

  # Methods

  def self.not_shipped
    joins(:order_items).where("order_items.shipped_on IS NULL").uniq!
  end

  def total_weight
    total = 0
    self.order_items.each do |i|
      total += i.item.weight * i.quantity
    end
    return total
  end

  def shipping_costs
    weight = self.total_weight.floor
    extra_pounds = weight - 3
    5 + (0.25 * extra_pounds)
  end

  private

  def user_is_active_in_system
    all_active_users = User.active.all.map(&:id)
    unless all_active_users.include?(self.user_id)
      errors.add(:user_id, "is not an active user at the chess store")
    end
  end

  def school_is_active_in_system 
    all_active_schools = School.active.all.map(&:id)
    unless all_active_schools.include?(self.school_id)
      errors.add(:school_id, "is not an active school at the chess store")
    end
  end

  def calculate_grand_total
    total_item_cost = get_item_prices
    shipping = shipping_costs
    self.update_attribute(:grand_total, shipping + total_item_cost)
  end

  # get the total prices of all the items
  def get_item_prices
    total = 0
    self.order_items.each do |i|
      total += i.item.current_price * i.quantity
    end
    return total
  end

end
