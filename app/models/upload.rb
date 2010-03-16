# == Schema Information
# Schema version: 20100316050953
#
# Table name: uploads
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

require 'csv'
class Upload < ActiveRecord::Base
  def self.import(upload)
    # save current patterns
    patterns = Pattern.all
    # save file to variable
    contents = upload['upload'].read
    contents.each do |row|
      line = CSV.parse_line(row)
      if line.length == 3 then
        date = Date.strptime(line[0], "%d/%m/%Y")
        amount = line[1]
        text = line[2]
        tr = Transaction.create(:statement_id => 1, :date => date, :amount => amount, :text => text)
      end
    end
  end
end
