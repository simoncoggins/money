# == Schema Information
# Schema version: 20100116225908
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
  has_many :tag_assignments, :dependent => :destroy
  has_many :tags, :through => :tag_assignments
  attr_accessible :date, :amount, :text

  validates_presence_of :date, :amount
  # how to check for float?
  validates_numericality_of :amount

end
