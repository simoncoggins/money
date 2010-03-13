# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # fix issue with negative numbers
  # would be nice to pass number_to_currency options argument
  # from this function 
  def as_currency(amount)
    if amount >= 0
      number_to_currency(amount)
    else
      '-' + number_to_currency(amount.abs)
    end
  end
end
