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
  belongs_to :statement
  has_many :tag_assignments, :dependent => :destroy, 
    :order => "source ASC, updated_at DESC"
  has_many :tags, :through => :tag_assignments, 
    :order => "source ASC, updated_at DESC"
  attr_accessible :date, :amount, :text

  validates_presence_of :date, :amount, :statement_id
  validates_numericality_of :amount
  validates_numericality_of :statement_id, :only_integer => true

  # could be done more efficiently with
  # extra field in transaction updated by
  # after_save method in tag_assignment
  def tag
    self.tags.find(:first)
  end

end
