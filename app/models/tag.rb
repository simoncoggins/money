# == Schema Information
# Schema version: 20100116225908
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  has_many :tag_assignments, :dependent => :destroy
  has_many :transactions, :through => :tag_assignments
  validates_presence_of :name
end
