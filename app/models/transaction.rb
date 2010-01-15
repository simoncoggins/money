# == Schema Information
# Schema version: 20100112082256
#
# Table name: transactions
#
#  id         :integer         not null, primary key
#  date       :date
#  amount     :float
#  text       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Transaction < ActiveRecord::Base
  attr_accessible :date, :amount, :text

  validates_presence_of :date, :amount
  # how to check for float?
  validates_numericality_of :amount

end
