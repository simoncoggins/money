class DataController < ApplicationController

  def bytag
    @from = params[:from]
    @to = params[:to]
    @result = 'Data By Tag'
    @period = params[:period]
    
    # find better way to do this
    if !@from.nil? and !@to.nil?
       by_tag = Transaction.find(:all, :conditions => ["amount < 0 AND date > ? AND date < ?", Time.at(@from.to_i), Time.at(@to.to_i)]).group_by(&:currtagid)
    elsif !@from.nil?
       by_tag = Transaction.find(:all, :conditions => ["amount < 0 ANDdate > ?", Time.at(@from.to_i)]).group_by(&:currtagid)
    elsif !@to.nil?
       by_tag = Transaction.find(:all, :conditions => ["amount < 0 AND date < ?", Time.at(@to.to_i)]).group_by(&:currtagid)
    else
       by_tag = Transaction.find(:all, :conditions => ["amount < 0"]).group_by(&:currtagid)
    end


# group by tags then a date period (days, weeks, etc)
# need to:
# - offset by 1/2 time period
# - pass width for bars
# - get stacking working
# - automate period based on url
# - pass tag info
# - consider using balance offset trick to show each transaction
#   as separate bar
    tags = Array.new
    series = Array.new
    tag_items = Array.new
    by_tag.each do |tagid,trs|
      points = Array.new
      period_items = Array.new

      by_period = trs.group_by {|tr| tr.date.beginning_of_day }
      by_period.each do |period, trs|
        items = Array.new
	sum = 0
        trs.each do |tr|
          sum += tr.amount.abs
          items << tr
        end
        time = period.to_time.to_i*1000
        points << [time, sum]
        period_items << trs
      end

      series << points
      tag_items << period_items
      tags << tagid
    end


# OTHER INFO:
# tasks are grouped by those with same return value from block
# task_months = @tasks.group_by{|t| t.due_at.beginning_of_month }
# to sort:
# task_months.keys.sort.each do |month|
# for task in task_months[month] do ...
#group_count = trs.count
#day_fraction = 1.0 / (group_count + 1)
#day_fraction =#  time = tr.date.to_time.to_i*1000 #+ day_fraction*(i+1)*60*60*24*1000
#day_fraction = 
    @data = {'data' => series,
             'tags' => tags,
             'items' => tag_items}.to_json

  end


end
