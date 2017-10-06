namespace :daily_updates do
  desc "TODO"
  task update_historical_data: :environment do
    Ticker.update_closing_prices
  end
end
