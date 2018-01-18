# https://api.iextrading.com/1.0/stock/qcln/quote

class IexTrading
  attr_accessor :object

  def initialize(object)
    self.object = object
  end

  def last_price
    attrs = {
      symbol: object.symbol,
    }
    api_call(attrs).parsed_response
  end 

private

  def api_call(attrs)
    HTTParty.get("https://api.iextrading.com/1.0/stock/#{attrs.fetch(:symbol)}/quote")
  end
end