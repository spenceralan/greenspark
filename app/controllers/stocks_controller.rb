class StocksController < ApplicationController
  def index
    @stocks = Stock.order(:symbol).page params[:page]
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def new
    @stock = Stock.new
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
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])
    if @stock.update(stock_params)
      flash[:notice] = "The stock has been updated."
      redirect_to stock_path(@stock)
    else
      render :edit
    end
  end

  def destroy
    Stock.find(params[:id]).destroy
    flash[:notice] = "The stock has been deleted."
    redirect_to root_path
  end





private
  def stock_params
    params.require(:stock).permit(:name, :symbol, :description)
  end

end
