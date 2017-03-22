require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # testing relationships
  should have_many(:orders)

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
  should_not allow_value("(908 123-1424").for(:phone)

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

end
