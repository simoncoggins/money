class ViewController < ApplicationController

  def index
    @data = Transaction.get_all_flot_data
  end

end