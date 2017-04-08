class Order < ActiveRecord::Base

  require 'base64'

  # credit card attributes
  attr_accessor :credit_card_number
  attr_accessor :expiration_year
  attr_accessor :expiration_month

  # additional attributes
  attr_reader :destroyable

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
  scope :for_school,    ->(school_id) { where(school_id: school_id) }

  # Validations
  validates_date :date, on_or_before: lambda { Date.current }
  # make sure grand_total is a valid number
  validates_numericality_of :grand_total, greater_than: 0, allow_blank: true
  # make sure required fields are present
  validates_presence_of :school_id, :user_id, :date
  validate :user_is_active_in_system
  validate :school_is_active_in_system
  validate :check_valid_card_number
  validate :check_valid_expr_date

  # Callbacks
  before_create :set_order_date
  before_destroy :is_destroyable?

  # Methods

  def self.not_shipped
    self.order_items.where("order_items.shipped_on IS NULL").uniq!
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

  def credit_card
    CreditCard.new(self.credit_card_number, self.expiration_year, self.expiration_month)
  end

  def credit_card_type
    unless credit_card.type.nil?
      credit_card.type
    else
      "N/A"
    end
  end

  def pay
    if self.payment_receipt.nil?
      receipt = Base64.encode64("order: #{self.id}; amount_paid: #{self.grand_total}; received: #{self.date}; card: #{self.credit_card_type} ****#{self.credit_card_number[-4..-1]}")
      self.update_attribute(:payment_receipt, receipt)
      self.save!
      self.payment_receipt
    else
      false
    end
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

  def check_valid_card_number 
    if self.expiration_year.nil? || self.expiration_month.nil?
      return false
    elsif credit_card.type.nil? || self.credit_card_number.nil?
      errors.add(:credit_card_number, "is not a valid card")
      return false
    else
      return true
    end
  end

  def check_valid_expr_date
    if self.credit_card_number.nil?
      return false
    elsif credit_card.expired? || self.expiration_year.nil? || self.expiration_month.nil?
      errors.add(:expiration_month, "is an expired card")
      return false
    else
      return true
    end
  end

  def set_order_date
    if self.date.nil? || self.date.class != Date || !self.date.respond_to?(:future?) || self.date.future?
      self.update_attribute(:date, Date.current)
    end
  end

  def is_destroyable?
    @destroyable = self.order_items.shipped.empty?
    if @destroyable
      self.order_items.each{|i| i.destroy}
    elsif !@destroyable
      self.oder_items.unshipped.each{|i| i.destroy}
    end
  end



end
