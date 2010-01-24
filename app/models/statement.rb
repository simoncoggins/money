class Statement < ActiveRecord::Base
  has_many :transactions
#  attr_accessible :name
  validates_presence_of :name
end
