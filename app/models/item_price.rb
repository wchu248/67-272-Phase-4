class ItemPrice < ActiveRecord::Base

  # Relationships
  belongs_to :item

  # Scopes
  scope :current,       -> { where(end_date:nil) }
  scope :chronological, -> { order(start_date: :desc ) }
  scope :for_date,      ->(date) { where("start_date <= ? AND (end_date > ? OR end_date IS NULL)", date, date) }
  scope :for_item,      ->(item_id) { where(item_id: item_id) }
  # returns all records where category is wholesale
  scope :wholesale,     -> { where("category = 'wholesale'") }
  # returns all records where category is manufacturer
  scope :manufacturer,  -> { where("category = 'manufacturer'") }

  # Validations
  validates_numericality_of :price, greater_than_or_equal_to: 0
  validates_date :start_date, on_or_before: lambda { Date.current }
  validates_date :end_date, on_or_after: :start_date, allow_blank: true
  validate :item_is_active_in_system
  # make sure the category is a valid one
  validates_inclusion_of :category, in: %w[wholesale manufacturer], message: 'is not an option'

  # Callbacks
  before_create :set_end_date_of_old_price
  before_destroy :is_never_destroyable?

  # Methods
  private
  def is_never_destroyable?
    false
  end

  def item_is_active_in_system
    all_active_items = Item.active.all.map(&:id)
    unless all_active_items.include?(self.item_id)
      errors.add(:item_id, "is not an active item at the chess store")
    end
  end

  def set_end_date_of_old_price
    previous = ItemPrice.where(category: self.category).current.for_item(self.item_id).take
    previous.update_attribute(:end_date, self.start_date) unless previous.nil?
  end
end
