# == Schema Information
# Schema version: 20100316050953
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
#  currtagid    :integer
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

  attr_accessible :date, :amount, :text, :statement_id, :currtagid
  after_create :apply_patterns

  # Input array of transactions as argument. If none provided, matches 
  # against all transactions
  # Returns array of tag ids and transactions of the form:
  # [ [tagid, [tr1, tr2, tr3, ..]], [anothertagid, ...], ... ]
  def self.group_by_tags(group=Transaction.all)
    raise "Not an array" unless group.instance_of?(Array)
    group.group_by(&:currtagid)
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
    self.amount < 0
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
      self.currtagid == tagid
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
    data = Array.new
    balance = 0.0
#    Transaction.find(:all, :order => 'date').each do |tr|
    Transaction.find(:all, :order => 'date,id DESC').group_by(&:date).each do |date, trs|
      group_count = trs.count
      day_fraction = 1.0 / (group_count + 1)

      trs.each_with_index do |tr, i|
        balance += tr.amount
        obj = {'id' => tr.id,
             'trdate' => tr.date, # avoid using JS reserved date
             'text' => tr.pretty_text,
             'amount' => tr.currency_amount,
             'statement_id' => tr.statement_id,
             'created_at' => tr.created_at,
             'updated_at' => tr.updated_at
        }
        time = tr.date.to_time.to_i*1000 + day_fraction*(i+1)*60*60*24*1000

        # may want to pass all transaction info as object
        data << [time, balance, obj.to_json]
      end
    end
    data
  end

  def pretty_text
    # capitalize first letter of each word, and compress multiple spaces
    self.text.split.map{|w| w.capitalize}.join ' '
  end

  def update_current_tag
    currtagid = (self.tag_assignments.empty?) ? 
      nil : self.tag_assignments.first.tag.id
    self.update_attribute(:currtagid, currtagid)
  end

  def tag
    if self.currtagid.nil?
      # return an empty tag so code like tr.tag.name will work
      # even if transaction is untagged
      Tag.new
    else
      Tag.find(self.currtagid) 
    end
  end

end

