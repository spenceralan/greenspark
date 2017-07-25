module StocksHelper
  def current_price(stock)
    api_call = RestClient.get("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{stock.symbol}&interval=1min&apikey=#{ENV.fetch('ALPHA_VANTAGE')}")
    last_price = JSON.parse(api_call)
    last_price.fetch("Time Series (1min)").first[1].fetch("4. close")
  end
end
