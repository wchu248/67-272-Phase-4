class CreditCard

  attr_reader :number, :type, :exp_year, :exp_month

  def initialize(number, exp_year, exp_month)
    @exp_year, @exp_month = exp_year, exp_month
    # need to change to string to match with regex
    @number = number.to_s
    @type = find_card_type
  end

  def find_card_type
    if /^3(4|7)[0-9]{13}$/.match(@number)
      "AMEX"
    elsif /^30[0-5][0-9]{11}$/.match(@number)
      "DCCB"
    elsif /(^6011[0-9]{12}$)|(^65[0-9]{14}$)/.match(@number)
      "DISC"
    elsif /^5[1-5][0-9]{14}$/.match(@number)
      "MC"
    elsif /^4\d{12}(\d{3})?$/.match(@number)
      "VISA"
    else
      nil
    end
  end

  # returns true if the card is expired (expiration date is before today)
  def expired?
    @exp_year < Date.today.year || (@exp_year == Date.today.year && @exp_month < Date.today.month)
  end

  # returns true if the card is valid (number is correct format and not expired)
  def valid?
    !type.nil? && !expired?
  end

end