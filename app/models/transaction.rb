# == Schema Information
# Schema version: 20100313000256
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

  validates_presence_of :date, :text, :amount, :statement_id
  validates_numericality_of :amount
  validates_numericality_of :statement_id, :only_integer => true

  attr_accessible :date, :amount, :text, :statement_id
  after_create :apply_patterns

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

  # needed by collection_select to pick default
  def tag_id
    self.tag.id
  end

  # Input array of transactions as argument. If none provided, matches 
  # against all transactions
  # Returns hash containing tagnames as keys and array of transactions
  # with that tag assigned as values
  def self.group_by_tags(group=Transaction.all)
    raise "Group is not an array" unless group.instance_of?(Array)
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

  # given an array of transactions, returns the ones where the
  # transactions are credits
  def self.get_credits(group=Transaction.all)
    raise "Not an array" unless group.instance_of?(Array)
    group.select do |tr|
      raise "Not a transaction" unless tr.instance_of?(Transaction)
      tr.credit?
    end
  end

  # given an array of transactions, returns the ones where the
  # transactions are debits
  def self.get_debits(group=Transaction.all)
    raise "Not an array" unless group.instance_of?(Array)
    group.select do |tr|
      raise "Not a transaction" unless tr.instance_of?(Transaction)
      tr.debit?
    end
  end

  def credit?
    self.amount >= 0
  end

  def debit?
    !self.credit?
  end

  # given an array of transactions, return the sum of all the amounts
  # involved, or 0 if there are no transactions
  def self.total_amount(group=Transaction.all)
    raise "Not an array" unless group.instance_of?(Array)
    group.map do |tr|
      raise "Not a transaction" unless tr.instance_of?(Transaction)
      tr.amount
    end.sum
  end

  # return a transaction's amount as a string with currency mark appended
  def currency_amount
    # define this elsewhere
    currencymark = '$'
    if self.credit?
      currencymark + self.amount.to_s
    else
      # remove first character (minus sign) and add before dollar
      '-' + currencymark + self.amount.to_s[1..-1]
    end
  end

  def assign_tag(tagid, source, source_info=nil)
    self.tag_assignments.create(:tag_id => tagid, :source => source, :source_info => source_info) unless
      # don't add an assignment if tag hasn't changed
      # this is a bit naive to assignments other than user
      # and could be handled better 
      self.tag.id == tagid
    true
  end

  def iscurrtag?(tagname)
    self.tag.name == tagname
  end

  # true if transaction name matches regexp
  def matches?(regexp)
    raise "Argument is not a regexp object" unless regexp.instance_of?(Regexp)
    !(self.text =~ regexp).nil?
  end

  # attempts to apply pattern provided to current transaction. If it matches
  # assign the pattern's tag and return true, otherwise return false
  def apply_pattern(pattern)
    raise "Not a pattern" unless pattern.instance_of?(Pattern)
    if self.matches?(pattern.regexp)
      self.assign_tag(pattern.tag_id, 2, pattern.id)
      true
    else
      false
    end
  end

  # try applying all the current patterns to current transaction. Stops 
  # after the first matching pattern
  def apply_patterns(patterns=Pattern.all)
    raise 'Not an array' unless patterns.instance_of?(Array)
    patterns.each do |pattern|
      raise 'Not a pattern' unless pattern.instance_of?(Pattern)
      if self.apply_pattern(pattern)
        # only apply first pattern
        return true
      end
    end
    false
  end

  def get_assigned_patterns
    # pattern based tag assignments assigned to this transaction
    tas = TagAssignment.find(:all, :conditions => { 
      :transaction_id => self.id, :source => 2})
    # return array of Patterns that created the assignments
    tas.map do |ta|
      Pattern.find(ta.source_info)
    end
  end

  def self.get_all_flot_data
    balance = 0.0
    @transactions = Transaction.find(:all, :order => 'date').map do |tr|
      balance += tr.amount
      [tr.date.to_time.to_i*1000, balance]
    end
  end

end

