class ViewController < ApplicationController

  def index
    @data = Transaction.get_all_flot_data
    @from = params[:from]
    @to = params[:to]
  end

  def other
    @tags = Tag.all
    @dateRange = {}
    @dateRange[:to] = params[:to] unless params[:to].nil?
    @dateRange[:from] = params[:from] unless params[:from].nil?
  end

end
