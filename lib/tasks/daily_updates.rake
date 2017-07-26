namespace :daily_updates do
  desc "TODO"
  task update_inactive_users: :environment do
    User.inactive_users.each do | user |
      user.stocks.each do | stock |
        stock.update_price
      end
    end
  end

end
