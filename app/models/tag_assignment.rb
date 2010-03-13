# == Schema Information
# Schema version: 20100313000256
#
# Table name: tag_assignments
#
#  id             :integer         not null, primary key
#  transaction_id :integer
#  tag_id         :integer
#  source         :integer
#  created_at     :datetime
#  updated_at     :datetime
#  source_info    :integer
#

class TagAssignment < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :tag

  validates_presence_of :tag_id, :transaction_id, :source
  validates_numericality_of :tag_id, :transaction_id, :source, :only_integer => true, :message => "can only be whole number."

  after_destroy :update_patterns

  # still not right - here newly assigned patterns will overrule any
  # existing ones, temporarily changed to only update if no other patterns
  # assigned (better than nothing)
  def update_patterns
    # only update assignments from patterns
    if self.source == 2 and transaction = self.transaction
      # now get array of all patterns assigned to this transaction
      existing_patterns = transaction.get_assigned_patterns 

      # candidates to try are any patterns not already assigned
      #candidates = Pattern.all - existing_patterns
      #transaction.apply_patterns(candidates)
      
      # only apply patterns if there are no others already set
      transaction.apply_patterns(Pattern.all) if existing_patterns.count == 0
    end
  end

end
