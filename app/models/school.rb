class School < ActiveRecord::Base

  # Taken from PATs example
  STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]

  # Additional accessors
  attr_reader :destroyable

  # Relationships
  # -----------------------------
  has_many :orders
  has_many :users, through: :orders

  # Scopes
  # -----------------------------
  # orders results alphabetically
  scope :alphabetical, -> { order(:name) }
  # returns all schools that are active in the system
  scope :active,       -> { where(active: true) }
  # returns all schools that are inactive in the system
  scope :inactive,     -> { where(active: false) } 

  # Validations
  # -----------------------------
  # make sure required fields are present
  validates_presence_of :name, :street_1, :zip
  # validates the format of zip codes
  validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
  # make sure the state is a valid US state abbreviation
  validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option", allow_blank: true
  # the min_grade cannot be negative 
  validates_numericality_of :min_grade, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: (12 || :max_grade)
  # the max_grade must be greater than or equal to min_grade
  validates_numericality_of :max_grade, only_integer: true, less_than_or_equal_to: 12, greater_than_or_equal_to: (0 || :min_grade)
  # check for duplicates only when a new school is being created
  validate :check_for_duplicates, on: :create

  # Callbacks
  # -----------------------------
  before_destroy :is_destroyable?
  after_rollback :make_school_inactive_instead_of_destroy

  # Methods
  # -----------------------------
  def already_exists?
    School.where(name: self.name, zip: self.zip).size == 1
  end

  def is_destroyable?
    @destroyable = self.orders.empty?
  end

  private

  def make_school_inactive_instead_of_destroy
    if !destroyable.nil? && !destroyable
      self.active = false
      @destroyable = nil
    end
  end

  def check_for_duplicates
    if self.already_exists?
      errors.add(:name, "has already been taken")
    end
  end

end