class User < ActiveRecord::Base

  # Use built-in rails support for password protection
  has_secure_password

  # Relationships
  # -----------------------------
  has_many :orders
  has_many :schools, through: :orders

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
  # validating password stuff
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long", allow_blank: true

  # Callbacks
  # -----------------------------
  before_destroy :is_never_destroyable?
  before_save :reformat_phone

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
  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  private

  # users can never be destroyed
  def is_never_destroyable?
    false
  end

  def reformat_phone
    self.phone = self.phone.to_s.gsub(/[^0-9]/,"")
  end

end
