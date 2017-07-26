namespace :hourly_updates do
  desc "TODO"
  task update_active_users: :environment do
    User.active_users.each do | user |
      user.stocks.each do | stock |
        stock.update_price
      end
    end
  end
end
