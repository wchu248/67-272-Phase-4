class OrderItem < ActiveRecord::Base

    # Relationships
    # -----------------------------
    belongs_to :item
    belongs_to :order

    # Scopes
    # -----------------------------
    scope :shipped,   -> { where.not(shipped_on:nil) }
    scope :unshipped, -> { where(shipped_on:nil) }

    # Validations
    # -----------------------------
    # make sure required fields are present
    validates_presence_of :order_id, :item_id, :quantity
    # make sure shipped_on is a valid date (not in the future)
    validates_date :shipped_on, on_or_before: lambda { Date.current }, allow_blank: true
    # make sure quantity is strictly positive
    validates_numericality_of :quantity, only_integer: true, greater_than: 0
    # restricts item_ids to items which exist and are active in the system
    validate :item_is_active_in_system

    # Methods
    # -----------------------------

    def subtotal(date = Date.current)
      return nil if !date.respond_to?(:future?) || date.future? || self.item.price_on_date(date).nil?
      self.item.price_on_date(date) * self.quantity
    end

    def shipped
      self.update_attribute(:shipped_on, Date.current)
      revised_inventory = self.item.inventory_level - self.quantity
      self.item.update_attribute(:inventory_level, revised_inventory)
    end

    private

    def item_is_active_in_system
      all_active_items = Item.active.all.map(&:id)
      unless all_active_items.include?(self.item_id)
        errors.add(:item_id, "is not an active item at the chess store")
      end
    end

end
