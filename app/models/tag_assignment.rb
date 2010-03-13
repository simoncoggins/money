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
end
