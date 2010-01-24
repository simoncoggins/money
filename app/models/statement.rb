# == Schema Information
# Schema version: 20100117080826
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
#  attr_accessible :name
  validates_presence_of :name
end
