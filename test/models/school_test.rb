require 'test_helper'

class SchoolTest < ActiveSupport::TestCase

  # test relationships
  should have_many(:orders)

  # test validations
  should validate_presence_of(:name)
  should validate_presence_of(:street_1)
  should validate_presence_of(:zip)

  should validate_uniqueness_of(:name).case_insensitive
  should validate_uniqueness_of(:zip).case_insensitive

  # Validating state...
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("OH").for(:state)

  should_not allow_value("bad").for(:state)
  should_not allow_value(10).for(:state)

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
      assert_equal ["Central School", "Ingomar Elementary", "Warren Middle School", "Watchung Hills Regional High School"], School.alphabetical.all.map(&:name)
    end

    # testing active and inactive scopes
    should "show that there are three active schools and one inactive school" do
      assert_equal ["Ingomar Elementary", "Central School", "Warren Middle School"], School.active.all.map(&:name)
      assert_equal ["Watchung Hills Regional High School"], School.inactive.all.map(&:name)
    end

    # test for creating duplicates
    should "show that a duplicate school cannot be created" do
      central_school2 = FactoryGirl.build(:school, name: "Central School", zip: "07059")
      deny central_school2.valid?
      central_school2.destroy
    end

  end

end