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
end
