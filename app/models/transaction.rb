# == Schema Information
# Schema version: 20100112082256
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
end
