class TransactionsController < ApplicationController

  def new
    @stock = current_user.stocks.find(params[:stock_id])
    @transaction = @stock.transactions.new
  end

  def create
    @stock = current_user.stocks.find(params[:stock_id])
    @transaction = @stock.transactions.new(transaction_params)
    if @transaction.save
      flash[:notice] = "The transaction has been added."
      redirect_to stock_path(@stock)
    else
      render :new
    end
  end

  def edit
    @stock = current_user.stocks.find(params.fetch(:stock_id))
    @transaction = @stock.transactions.find(params[:id])
  end

  def update
    @transaction = @stock.transactions.find(params[:id])
    if @transaction.update(transaction_params)
      flash[:notice] = "The transaction has been updated."
      redirect_to stock_path(@transaction.stock)
    else
      render :edit
    end
  end

  def destroy
    stock = current_user.stocks.find(params[:stock_id])
    @stock.transactions.find(params[:id]).destroy
    flash[:notice] = "The transaction was sucessfully deleted."
    redirect_to stock_path(stock)
  end

private
  def transaction_params
    params.require(:transaction).permit(:trade_type, :price, :quantity, :date)
  end

end
