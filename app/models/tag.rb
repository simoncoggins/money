class Tag < ActiveRecord::Base
  has_many :tag_assignments
  has_many :transactions, :through => :tag_assignments
  validates_presence_of :name
end
