class AlphaVantage
  attr_accessor :object

  def initialize(object)
    self.object = object
  end

  def full_closing_price_history
    attrs = {
      function: "TIME_SERIES_DAILY",
      symbol: object.symbol,
      outputsize: "full",
      datatype: "csv",
      apikey: ENV.fetch('ALPHA_VANTAGE'),
    }
    response = api_call(attrs)
    CSV.parse(response.to_s, headers: :first_row)
  end

  def compact_closing_price_history
    attrs = {
      function: "TIME_SERIES_DAILY",
      symbol: object.symbol,
      outputsize: "compact",
      datatype: "csv",
      apikey: ENV.fetch('ALPHA_VANTAGE'),
    }
    response = api_call(attrs)
    CSV.parse(response.to_s, headers: :first_row)
  end

  def last_price
    attrs = {
      function: "TIME_SERIES_INTRADAY",
      symbol: object.symbol,
      interval: "1min",
      apikey: ENV.fetch('ALPHA_VANTAGE'),
    }
    response = api_call(attrs)
    JSON.parse(response)
  end 

private

  def api_call(attrs)
    RestClient.get("https://www.alphavantage.co/query?#{attrs_to_string(attrs)}")
  end

  def attrs_to_string(attrs)
    string_segments = []
    attrs.each do |attr|
      string_segments << "#{attr[0].to_s}=#{attr[1].to_s}"
    end
    string_segments.join("&")
  end
end