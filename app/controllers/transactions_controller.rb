class TransactionsController < ApplicationController

  def index
    @untagged = Transaction.untagged
    @tags = Tag.all
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
    if @transaction.save
      flash[:notice] = 'Transaction saved!'
      redirect_to :controller => 'transactions', :action => 'new'
    else
      render :action => 'new'
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @transaction[:tag_id] = @transaction.tag
  end

  def update
    @transaction = Transaction.find(params[:id])
    tagid = params[:transaction].delete('tag_id')
    if @transaction.update_attributes(params[:transaction]) and
      @transaction.createusertag(tagid)
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
end
