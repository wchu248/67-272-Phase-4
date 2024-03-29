require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should have_secure_password

  # testing relationships
  should have_many(:orders)
  should have_many(:schools).through(:orders)

  # testing validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)
  should validate_presence_of(:username)
  should validate_presence_of(:password_digest)
  should validate_presence_of(:role)

  should validate_uniqueness_of(:username).case_insensitive
  should validate_uniqueness_of(:email).case_insensitive

  should validate_inclusion_of(:role).in_array(%w[admin customer manager shipper])

  # validating role...
  should allow_value("admin").for(:role)
  should allow_value("customer").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("shipper").for(:role)

  should_not allow_value("user").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value(0).for(:role)
  should_not allow_value(3.days.ago.to_date).for(:role)
  should_not allow_value(nil).for(:role)

  # validating phone
  should allow_value("123-456-7890").for(:phone)
  should allow_value("123.456.7890").for(:phone)
  should allow_value("(123) 456-7890").for(:phone)
  should allow_value("123 456 7890").for(:phone)
  should allow_value("1234567890").for(:phone)

  should_not allow_value("123-4567").for(:phone)
  should_not allow_value("12345678901").for(:phone)
  should_not allow_value("bad").for(:phone)
  should_not allow_value("(9083) 123-1424").for(:phone)

  # validating email
  should allow_value("wchu27@gmail.com").for(:email)
  should allow_value("winston.chu@gmail.com").for(:email)
  should allow_value("winston_chu@gmail.com").for(:email)
  should allow_value("123@gmail.com").for(:email)

  should_not allow_value(0).for(:email)
  should_not allow_value("hello").for(:email)
  should_not allow_value("winston@chu@gmail.com").for(:email)
  should_not allow_value("winston@gmail").for(:email)
  should_not allow_value("winston@.com").for(:email)
  should_not allow_value("@gmail.com").for(:email)

  # testing other scopes/methods with a context
  context "Within context" do

    setup do 
      create_users
    end

    teardown do
      destroy_users
    end

    # testing active and inactive scopes
    should "show that there are four active users and one inactive user" do
      assert_equal ["Winston", "Allie", "Jack", "Sean"], User.active.all.map(&:first_name)
      assert_equal ["Inactive"], User.inactive.all.map(&:first_name)
    end

    should "show that there are four employees and one customer" do
      assert_equal ["Winston", "Jack", "Sean", "Inactive"], User.employees.all.map(&:first_name)
      assert_equal ["Allie"], User.customers.all.map(&:first_name)
    end

    # testing alphabetical scope
    should "show that there are five users in in alphabetical order" do
      assert_equal ["acaron", "inact_use", "jhlance", "seanande1", "wpchu"], User.alphabetical.all.map(&:username)
    end

    # testing name method
    should "show that the name method returns the correct output" do
      assert_equal "Chu, Winston", @winston_chu.name
      assert_equal "Caron, Allie", @allie_caron.name
    end

    # testing proper_name method
    should "show that the proper_name method returns the correct output" do
      assert_equal "Winston Chu", @winston_chu.proper_name
      assert_equal "Allie Caron", @allie_caron.proper_name
    end

    # testing role? method
    should "show that the role? method returns the correct output" do
      assert @winston_chu.role?(:admin)
      deny @winston_chu.role?(:customer)
      assert @allie_caron.role?(:customer)
      deny @sean_anderson.role?(:manager)
    end

    # testing that phone numbers are reformatted properly
    should "show that phone numbers are reformatted properly" do
      assert_equal "9088388767", @winston_chu.phone
      assert_equal "1234567890", @inactive_user.phone
      assert_nil @sean_anderson.phone
    end

    # testing that uses can never de destroyed
    should "show that users can never be destroyed" do 
      deny @winston_chu.destroy
      deny @allie_caron.destroy
      deny @jack_lance.destroy
      deny @sean_anderson.destroy
      deny @inactive_user.destroy
    end

    # testing unique emails
    should "require users to have unique emails" do
      @bad_user = FactoryGirl.build(:user, first_name: "John", email: "wchu27@gmail.com")
      deny @bad_user.valid?
    end

    # testing unique usernames
    should "require users to have unique usernames" do
      @bad_user2 = FactoryGirl.build(:user, first_name: "John", username: "wpchu")
      deny @bad_user2.valid?
      @bad_user3 = FactoryGirl.build(:user, first_name: "John", username: "WPchu")
      deny @bad_user3.valid?
    end
    
    # new users need to have a password
    should "require a password for new users" do
      @bad_user4 = FactoryGirl.build(:user, first_name: "John", password: nil)
      deny @bad_user4.valid?
    end
    
    # passwords must be properly confirmed
    should "require passwords to be confirmed and matching" do
      @bad_user5 = FactoryGirl.build(:user, first_name: "John", password: "secret", password_confirmation: nil)
      deny @bad_user5.valid?
      @bad_user6 = FactoryGirl.build(:user, first_name: "John", password: "secret", password_confirmation: "sauce")
      deny @bad_user6.valid?
    end
    
    # testing that passwords are at least 4 characters in length
    should "require passwords to be at least four characters" do
      @bad_user7 = FactoryGirl.build(:user, first_name: "John", password: "no")
      deny @bad_user7.valid?
      @bad_user8 = FactoryGirl.build(:user, first_name: "John", password: "hello")
      deny @bad_user8.valid?
    end

  end

end
