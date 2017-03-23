class OrderItem < ActiveRecord::Base

    # Relationships
    # -----------------------------
    belongs_to :item
    belongs_to :order

    # Scopes
    # -----------------------------


    # Validations
    # -----------------------------
    # restricts item_ids to items which exist and are active in the system
    validate :item_is_active_in_system

    # Methods
    # -----------------------------

    private

    def item_is_active_in_system
      all_active_items = Item.active.all.map(&:id)
      unless all_active_items.include?(self.item_id)
        errors.add(:item_id, "is not an active item at the chess store")
      end
    end

end
