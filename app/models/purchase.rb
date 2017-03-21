class Purchase < ActiveRecord::Base
  # Relationships
  belongs_to :item

  # Scopes
  scope :loss,          -> { where('quantity < 0') }
  scope :chronological, -> { order(date: :desc ) }
  scope :for_item,      ->(item_id) { where(item_id: item_id) }

  # Validations
  validates_numericality_of :quantity, only_integer: true
  validates_date :date, on_or_before: lambda { Date.current }
  validate :item_is_active_in_system

  # Callbacks
  before_create :update_item_inventory_level

  private
  def item_is_active_in_system
    all_active_items = Item.active.all.map(&:id)
    unless all_active_items.include?(self.item_id)
      errors.add(:item_id, "is not an active item at the chess store")
    end
  end

  def update_item_inventory_level
    revised_inventory = self.item.inventory_level + self.quantity
    self.item.update_attribute(:inventory_level, revised_inventory)
  end
end
