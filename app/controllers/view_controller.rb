class ViewController < ApplicationController

  def index
    @data = Transaction.get_all_flot_data
    @from = params[:from]
  end

end
