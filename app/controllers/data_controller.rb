class DataController < ApplicationController

# group by tags then a date period (days, weeks, etc)
# need to:
# - pass width for bars?
# - consider using balance offset trick to show each transaction
#   as separate bar

  def bytag
    @period = params[:period].downcase
    
    by_tag = Transaction.get_by_dates(:from => params[:from], :to => params[:to]).group_by(&:currtagid)

    tags = Array.new
    series = Array.new
    tag_items = Array.new

    # get a list of all unique transaction dates
    all_periods = by_tag.values.flatten.map{|tr| tr.date_by_period(@period)}.uniq 

    # get current tags, including untagged
    all_tags = Tag.all
    all_tags << Tag.new(:name => 'untagged', :color => '#999999')

    by_tag.each do |tagid,trs|
      # get the tag object for this grouping
      # must be an easier/more efficient way
      this_tag = all_tags.select{|t| t.id == tagid }[0]

      # split each tags data by date period
      by_period = trs.group_by {|tr| tr.date_by_period(@period) }

      points = Array.new
      period_items = Array.new

      # go through all the possible time periods
      all_periods.each do |thisperiod|

        time = thisperiod.to_time.to_i*1000
        items = Array.new
        sum = 0
        # does this grouping have transactions for this time period?
        if by_period.has_key?(thisperiod)
          by_period[thisperiod].each do |tr|
            # add amounts and store transaction info
            sum += tr.amount.abs
            obj = {'id' => tr.id,
             'trdate' => tr.date, # avoid using JS reserved date
             'text' => tr.pretty_text,
             'amount' => tr.currency_amount,
             'statement_id' => tr.statement_id,
             'created_at' => tr.created_at,
             'updated_at' => tr.updated_at
            }
            items << obj
          end
        end
        # build the series
        points << [time, sum]
        period_items << items.sort{|x,y| x['trdate'] <=> y['trdate']}

      end 

      datainfo = Hash.new
      datainfo['data'] = points
      datainfo['color'] = this_tag.color

      # build the tagged groups
      series << datainfo
      tag_items << period_items
      tags << this_tag
    end


    @data = {'data' => series,
             'tags' => tags,
             'items' => tag_items}.to_json

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


end
