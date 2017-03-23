require 'test_helper'

class SchoolTest < ActiveSupport::TestCase

  # test relationships
  should have_many(:orders)

  # test validations
  should validate_presence_of(:name)
  should validate_presence_of(:street_1)
  should validate_presence_of(:zip)

  should validate_inclusion_of(:state).in_array(School::STATES_LIST.to_h.values)
  should_not allow_value("Pennsylvania").for(:state)

  # Validating zip codes...
  should allow_value("03412").for(:zip)
  should allow_value("12345").for(:zip)
  should allow_value("99999").for(:zip)

  should_not allow_value("bad").for(:zip)
  should_not allow_value("0123").for(:zip)
  should_not allow_value("12h3").for(:zip)
  should_not allow_value(1521).for(:zip)
  should_not allow_value(nil).for(:zip)

  # Validating min_grade...
  should allow_value(1).for(:min_grade)
  should allow_value(0).for(:min_grade)

  should_not allow_value(13).for(:min_grade)
  should_not allow_value(-1).for(:min_grade)
  should_not allow_value(1.5).for(:min_grade)
  should_not allow_value("bad").for(:min_grade)

  # testing other scopes/methods with a context
  context "Within context" do

    setup do 
      create_schools
    end

    teardown do
      destroy_schools
    end

    # testing alphabetical scope
    should "show that there are four schools in in alphabetical order" do
      assert_equal ["Central School", "Central School", "Ingomar Elementary", "Warren Middle School", "Watchung Hills Regional High School"], School.alphabetical.all.map(&:name)
    end

    # testing active and inactive scopes
    should "show that there are three active schools and one inactive school" do
      assert_equal ["Ingomar Elementary", "Central School", "Warren Middle School", "Central School"], School.active.all.map(&:name)
      assert_equal ["Watchung Hills Regional High School"], School.inactive.all.map(&:name)
    end

    # test for creating duplicates
    should "show that a duplicate school cannot be created" do
      central_school2 = FactoryGirl.build(:school, name: "Central School", zip: "07059")
      deny central_school2.valid?
      central_school2.destroy
    end

    should "show that a school with the same name can be created in the same town" do
      assert @central_school3.valid?
    end

    should "show that min_grade and max_grade can be the same" do
      assert @warren_middle.valid?
    end

    should "show that a school cannot have a max_grade larger than a min_grade" do
      bad_school = FactoryGirl.build(:school, name: "bad school", zip: "91924", min_grade: 6, max_grade: 4)
      deny bad_school.valid?
      bad_school.destroy
    end

    # testing max_grade...
    should "show that max_grade is valid and invalid where it should be" do
      assert @ingomar_elem.valid?
      assert @warren_middle.valid?
      @bad_school1 = FactoryGirl.build(:school, max_grade: -1)
      deny @bad_school1.valid?
      @bad_school2 = FactoryGirl.build(:school, max_grade: 13)
      deny @bad_school2.valid?
      @bad_school3 = FactoryGirl.build(:school, max_grade: 1.5)
      deny @bad_school3.valid?
      @bad_school4 = FactoryGirl.build(:school, max_grade: "bad")
      deny @bad_school4.valid?
    end

  end

end