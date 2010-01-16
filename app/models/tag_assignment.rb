class TagAssignment < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :tag
  validates_presence_of :tag_id, :transaction_id, :source
  validates_numericality_of :tag_id, :transaction_id, :source

end
