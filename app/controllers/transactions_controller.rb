class TransactionsController < ApplicationController

  def index
    # get an ordered list of tags
    @tags = Tag.find(:all, :order => 'name')
    # add a dummy tag to the array so untagged transactions will
    # also be shown
    # bit of a hack as this throws a warning - might be better to
    # split transaction/index view into a partial and treat untagged
    # as a special case
    @tags << Tag.new(:name => 'untagged', :id=>nil)
    # get all transactions in an array, by tag
    # untagged transactions have a key of nil
    @grouped_transactions = Transaction.group_by_tags
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.statement_id = 1
    tagid = params[:transaction].delete('tag_id')
    if @transaction.save and @transaction.assign_tag(tagid, 1)
      flash[:notice] = 'Transaction saved!'
      redirect_to :controller => 'transactions', :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @transaction[:tag_id] = @transaction.tag.id
  end

  def update
    @transaction = Transaction.find(params[:id])
    tagid = params[:transaction].delete('tag_id')
    if @transaction.update_attributes(params[:transaction]) and
      @transaction.assign_tag(tagid, 1)
      flash[:notice] = 'Information updated'
      redirect_to transaction_url(@transaction)
    else
      flash[:error] = 'Could not update'
      render :action => 'edit'
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    flash[:notice] = 'Transaction was deleted'
    redirect_to transactions_url
  end

  def split
    @transaction = Transaction.find(params[:id])
    halfamount = @transaction.amount / 2
    @halfup = (halfamount*100).ceil/100.0
    @halfdown = (halfamount*100).floor/100.0
  end

  def dosplit
    @transaction = Transaction.find(params[:id])
    tagid = params[:transaction].delete('tag_id')

    @newtransaction = Transaction.new(params[:newtransaction])
    newtagid = params[:newtransaction].delete('tag_id')
    params[:newtransaction][:currtagid] = newtagid
    if @transaction.update_attributes(params[:transaction]) and
      @transaction.assign_tag(tagid, 1) and
      @newtransaction.save and 
      @newtransaction.assign_tag(newtagid, 1)
      flash[:notice] = 'Transaction split'
      redirect_to :action => 'index'
    else
      flash[:error] = 'Could not split transaction'
      render :action => 'index'
    end

 


  end
end
