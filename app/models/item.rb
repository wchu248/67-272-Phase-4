class Item < ActiveRecord::Base
  # List of allowable categories
  CATEGORIES = [['Boards','boards'],['Pieces','pieces'],['Clocks','clocks'],['Supplies','supplies']]
  
  # Relationships
  has_many :item_prices
  has_many :purchases
  has_many :order_items

  # Scopes
  scope :alphabetical, -> { order(:name) }
  scope :active,       -> { where(active: true) }
  scope :inactive,     -> { where(active: false) }
  scope :for_category, ->(category) { where(category: category) }
  scope :for_color,    ->(color) { where("color like ?", "%#{color.downcase}%") }
  scope :need_reorder, ->{ where("reorder_level >= inventory_level") }
  
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_numericality_of :weight, greater_than: 0
  validates_numericality_of :inventory_level, only_integer: true, greater_than_or_equal_to: 0
  validates_numericality_of :reorder_level, only_integer: true, greater_than_or_equal_to: 0
  validates_inclusion_of :category, in: CATEGORIES.map{|key, value| value}, message: "is not an option"

  # Other methods
  def current_price
    curr = self.item_prices.wholesale.current.chronological.first
    return nil if curr.nil?
    curr.price
  end

  def current_manufacturer_price
    curr = self.item_prices.manufacturer.current.chronological.first
    return nil if curr.nil?
    curr.price
  end

  def price_on_date(date)
    data = self.item_prices.for_date(date).wholesale.chronological.first
    return nil if data.nil?
    data.price
  end

  def manufacturer_price_on_date(date)
    data = self.item_prices.for_date(date).manufacturer.chronological.first
    return nil if data.nil?
    data.price
  end

  def reorder?
    reorder_level >= inventory_level
  end
end
