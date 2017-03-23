class User < ActiveRecord::Base

  # Relationships
  # -----------------------------
  has_many :orders

  # Scopes
  # -----------------------------
  # returns only active users
  scope :active,       -> { where(active: true) }
  # returns all inactive users
  scope :inactive,     -> { where(active: false) }
  # returns all non-customer users
  scope :employees,    -> { where("role <> 'customer'") }
  # returns all customer users
  scope :customers,    -> { where("role = 'customer'") }
  # orders results alphabetically by username
  scope :alphabetical, -> { order(:username) }

  # Validations
  # -----------------------------
  # make sure all required fields are present
  validates_presence_of :first_name, :last_name, :email, :username, :password_digest, :role
  # each username must be unique, regardless of case
  validates :username, uniqueness: { case_sensitive: false }
  # each email must be unique, regardless of case
  validates :email, uniqueness: { case_sensitive: false }
  # the role of each user must be one of 4 available roles
  validates_inclusion_of :role, in: %w[admin customer manager shipper], message: 'is not an option'
  # make sure phone numbers have correct format
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-. ]\d{4})\z/, message: "is not a valid format"
  # make sure emails have correct format
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net))\z/i, message: "is not a valid format"

  # Callbacks
  # -----------------------------
  before_destroy :cannot_be_destroyed

  # Methods
  # -----------------------------
  # gets owner name in last, first format
  def name
    last_name + ", " + first_name
  end

   # gets owner name in first last format
  def proper_name
    first_name + " " + last_name
  end

  # checks if parameter matches user role
  def role?(x)
    return false if self.role.nil?
    x == self.role.downcase.to_sym 
  end

end
