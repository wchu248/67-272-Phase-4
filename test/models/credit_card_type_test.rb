require 'test_helper'

class CreditCardTypeTest < ActiveSupport::TestCase

  # checking that name and pattern return correct things (shouldn't be too hard)

  def test_returns
    test_card = CreditCardType.new("VISA", /^4\d{12}(\d{3})?$/)
    assert_equal "VISA", test_card.name
    assert_equal /^4\d{12}(\d{3})?$/, test_card.pattern
  end

end