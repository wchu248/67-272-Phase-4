class Order < ActiveRecord::Base

  # Relationships
  has_many :order_items
  has_many :items, through: :order_items
  belongs_to :users
  belongs_to :school

  # Validations
  validate :user_is_active_in_system
  validate :school_is_active_in_system

  # Methods

  private

  def user_is_active_in_system

  end

  def school_is_active_in_system 
    
  end

end
