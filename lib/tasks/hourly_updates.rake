namespace :hourly_updates do
  desc "TODO"
  task update_tickers: :environment do
    Ticker.find_each do | ticker |
      ticker.update_price
    end
  end
end
