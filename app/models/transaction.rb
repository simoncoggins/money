# == Schema Information
# Schema version: 20100117080826
#
# Table name: transactions
#
#  id           :integer         not null, primary key
#  date         :date
#  amount       :float
#  text         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  statement_id :integer
#

class Transaction < ActiveRecord::Base
  belongs_to :statement
  has_many :tag_assignments, :dependent => :destroy, 
    :order => "source ASC, updated_at DESC"
  has_many :tags, :through => :tag_assignments, 
    :order => "source ASC, updated_at DESC"
  attr_accessible :date, :amount, :text, :statement_id

  validates_presence_of :date, :text, :amount, :statement_id
  validates_numericality_of :amount
  validates_numericality_of :statement_id, :only_integer => true

  # could be done more efficiently with
  # extra field in transaction updated by
  # after_save method in tag_assignment
  def tag
    if self.tag_assignments.empty?
      # no tags, provide an empty tag so transaction.tag.name works
      Tag.new
    else
      self.tag_assignments.first.tag
    end
  end

  # Input array of transactions as argument. If none provided, matches 
  # against all transactions
  # Returns hash containing tagnames as keys and array of transactions
  # with that tag assigned as values
  def self.group_by_tags(group=Transaction.all)
    raise "Group is not an array" unless group.kind_of?(Array)
    result = Hash.new()
    group.each do |tr|
      raise "Group item is not a transaction" unless tr.instance_of?(Transaction)
      tagname = tr.tag.name || 'untagged'
      if result.has_key?(tagname)
        # add to array
        result[tagname] << tr
      else
        # start the array
        result[tagname] = [tr] 
      end
    end
    result
  end

  def assign_tag(tagid, source)
    self.tag_assignments.create(:tag_id => tagid, :source => source) unless
      # don't add an assignment if tag hasn't changed
      # this is a bit naive to assignments other than user
      # and could be handled better 
      self.tag.id == tagid
    true
  end

  def iscurrtag?(tagname)
    self.tag.name == tagname
  end
end
