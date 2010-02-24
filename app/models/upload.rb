class Upload < ActiveRecord::Base
  def self.import(upload)
    # how to read in uploaded file?
    @contents = upload['upload'].read
  end
end
