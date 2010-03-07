require 'csv'
require 'logger'
class Upload < ActiveRecord::Base
  def self.import(upload)
    # save file to variable
    log = Logger.new(STDOUT)
    contents = upload['upload'].read
    contents.each do |row|
    line = CSV.parse_line(row)
      if line.length == 3 then
        date = Date.strptime(line[0], "%d/%m/%Y")
        amount = line[1]
        text = line[2]
        log.info([date, amount, text])
        tr = Transaction.create(:statement_id => 1, :date => date, :amount => amount, :text => text)
        log.info(tr)
      end
    end
  end
end
