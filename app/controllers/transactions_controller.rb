class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
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
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update_attributes(params[:transaction])
      flash[:notice] = 'Information updated'
      redirect_to transaction_url(@transaction)
    else
      flash[:error] = 'Could not update'
      render :action => 'edit'
    end
  end

end
