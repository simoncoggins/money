# == Schema Information
# Schema version: 20100311074344
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
  attr_accessible :pattern, :tag_id
  validates_presence_of :tag_id, :pattern
  validates_numericality_of :tag_id

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
end
