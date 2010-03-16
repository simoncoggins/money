# == Schema Information
# Schema version: 20100316050953
#
# Table name: patterns
#
#  id         :integer         not null, primary key
#  pattern    :string(255)
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#
class Pattern < ActiveRecord::Base
  belongs_to :tag

  validates_presence_of :tag_id, :pattern
  validates_numericality_of :tag_id

  attr_accessible :pattern, :tag_id
  default_scope :order => 'updated_at DESC'

  # update tag_assignments for transactions when patterns change
  after_save :update_assignments
  after_destroy :remove_assignments

  # following the creation of a new pattern or an update to an 
  # existing pattern, update pattern assignments
  def update_assignments
    # for new patterns this should be empty
    existing_trs = self.get_assigned_transactions
    # transactions the pattern matches now
    current_trs = self.get_matches

    # for transactions that still match, just update the tag
    still_matches = existing_trs & current_trs
    still_matches.each do |tr|
      # assume only one ta per source and source_info
      # might want to enforce this constraint in model and db
      # problem is, this isn't updating it!
      tr.tag_assignments.find_by_source_and_source_info(2, 
        self.id).update_attribute(:tag_id, self.tag_id)
    end

    # for transactions that no longer match, remove the tag assignment
    # like when deleting patterns, might want to check if other patterns
    # below this one now match? Could do this with after_destroy in 
    # TagAssignment model??
    no_longer_matches = existing_trs - current_trs
    no_longer_matches.each do |tr|
      tr.tag_assignments.find_by_source_and_source_info(2, 
        self.id).destroy if self.has_attribute?('id')
      # this is not called at the moment when ta's are destroyed
      tr.update_current_tag
    end

    new_matches = current_trs - existing_trs
    # apply new or modified pattern to those that need it
    self.apply_to_transactions(new_matches)

  end

  # remove any assignments by pattern when it is destroyed
  def remove_assignments
  #  tas = TagAssignment.find_all_by_source_and_source_info(2, self.id)
  #  tas.each do |ta|
  #    ta.destroy
  #  end
  #  tas.count

    # this does the same as above with less queries, but doesn't apply
    # any callbacks (none needed in this case)
    TagAssignment.destroy_all(:source => 2, 
      :source_info => self.id) if self.has_attribute?('id') 
  end

  def regexp
    # escape all characters, except * as wildcard
    re = Regexp.escape(self.pattern).gsub('\*','.*')
    Regexp.new(re, true) # case insensitive
  end  

  # assigns tag and returns boolean indicating if pattern matched
  def apply_to_transaction(transaction)
    transaction.apply_pattern(self)
  end

  def apply_to_transactions(transactions=Transaction.all)
    raise "Not an array" unless transactions.instance_of?(Array)
    # store matched patterns
    applied = transactions.select do |transaction|
      raise "Not a transaction" unless transaction.instance_of?(Transaction)
      # assigns pattern and returns true on successful match
      transaction.apply_pattern(self)
    end
    # returns number of matched transactions
    applied.count
  end

  # given an array of transactions, returns an array of those that
  # match the pattern, or an empty array if none do
  # if no argument given, compares all transactions
  def get_matches(transactions=Transaction.all)
    raise "not an array" unless transactions.instance_of?(Array)
    transactions.select do |tr|
      raise "Not a transaction" unless tr.instance_of?(Transaction)
      tr.matches?(self.regexp) 
    end
  end

  # returns an array of transactions that have tag assignments to this
  # pattern. This may be different from the output from get_matches as
  # some transactions may be matched by an earlier pattern
  def get_assigned_transactions
    # find tag assignments relating to this pattern
    TagAssignment.find_all_by_source_and_source_info(2, self.id).map do |ta|
      # get the transaction to which the assignment refers
      ta.transaction
    end
  end

end
