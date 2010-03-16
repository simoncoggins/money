# == Schema Information
# Schema version: 20100316050953
#
# Table name: statements
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Statement < ActiveRecord::Base
  has_many :transactions

  validates_presence_of :name
end
