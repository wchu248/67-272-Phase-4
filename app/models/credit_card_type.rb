# A class for generating types of credit cards, such as VISA, DISC, MC, DCCB, etc (all the card types from lab 10)
class CreditCardType

  attr_reader :name, :pattern

  def initialize(name, pattern)
    @name, @pattern = name, pattern
  end

end