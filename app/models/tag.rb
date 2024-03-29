# == Schema Information
# Schema version: 20100325080503
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  color      :string(255)
#

class Tag < ActiveRecord::Base
  has_many :tag_assignments, :dependent => :destroy,
    :order => "source ASC, updated_at DESC"
  has_many :transactions, :through => :tag_assignments,
    :order => "source ASC, updated_at DESC"
  has_many :patterns

  validates_presence_of :name
end
