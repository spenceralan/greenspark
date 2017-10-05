class StocksController < ApplicationController
  def index
    @stocks = current_user.stocks.order(:symbol).page params[:page]
  end

  def show
    @stock = current_user.stocks.find(params[:id])
    @transactions = @stock.transactions_by_date_descending
  end

  def new
    @stock = current_user.stocks.new
    render :new
  end

  def create
    @stock = current_user.stocks.new(stock_params)
    if @stock.save
      flash[:notice] = "Your stock has been saved."
      redirect_to stock_path(@stock)
    else
      render :new
    end
  end

  def edit
    @stock = current_user.stocks.find(params[:id])
  end

  def update
    @stock = current_user.stocks.find(params[:id])
    if @stock.update(stock_params)
      flash[:notice] = "The stock has been updated."
      redirect_to stock_path(@stock)
    else
      render :edit
    end
  end

  def destroy
    current_user.stocks.find(params[:id]).destroy
    flash[:notice] = "The stock has been deleted."
    redirect_to stocks_path
  end

  def to_buy
    budget = stock_to_buy_params.fetch(:budget).to_f
    @stocks_to_buy = Algorithm.new(current_user, budget)
    respond_to do |format|
      format.js
    end
  end

private
  def stock_params
    params.require(:stock).permit(:name, :symbol, :description)
  end

  def stock_to_buy_params
    params.permit(:budget)
  end
end
