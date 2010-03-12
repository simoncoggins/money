class PatternsController < ApplicationController

  def index
    @patterns = Pattern.all
  end

  def show
    @pattern = Pattern.find(params[:id])
  end

  def new
    @pattern = Pattern.new
  end

  def create
    @pattern = Pattern.new(params[:pattern])
    if @pattern.save
      # now assign tags based on the new pattern
      @pattern.apply_to_transactions
      flash[:notice] = 'Pattern saved!'
      redirect_to :controller => 'patterns', :action => 'new'
      # at this point we may want to reanalyse any untagged
      # transactions to see if they match this pattern
      # if so maybe the user should see what was assigned and
      # have the option to change it?
    else
      render :action => 'new'
    end
  end

  def edit
    @pattern = Pattern.find(params[:id])
  end

  def update
    @pattern = Pattern.find(params[:id])
    if @pattern.update_attributes(params[:pattern])
      flash[:notice] = 'Information updated'
      redirect_to pattern_url(@pattern)
    else
      flash[:error] = 'Could not update'
      render :action => 'edit'
    end
  end

  def destroy
    @pattern = Pattern.find(params[:id])
    @pattern.destroy
    flash[:notice] = 'Pattern was deleted'
    redirect_to patterns_url
  end
end

