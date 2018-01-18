# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



def create_test_user(budget, start_date, frequency, incremental)

  User.find_by(username: "testuser#{budget}#{frequency}")&.destroy

  user = User.create(
    username: "testuser#{budget}#{frequency}",
    email: "testuser#{budget}#{frequency}@test.com",
    password: "test123",
    password_confirmation: "test123",
    incremental: incremental
  )
  
  date = start_date
  
  while date < Date.today
    user.stocks.each do |stock|
      closing_price = stock.ticker.closing_price(date)
      if closing_price.present?
        stock.ticker.update_attribute(:last_updated_price, closing_price.first.price)
      end
    end
  
    algorithm = Algorithm.new(user, budget)
  
    algorithm.stocks_to_purchase.each do |stock|
      quantity = stock.fetch(:quantity)
      stock = stock.fetch(:stock)
      stock.transactions.create!(
        date: date,
        quantity: quantity,
        price: stock.ticker.last_updated_price,
        trade_type: "buy",
        user: user
      )
    end
  
    date += frequency
  end

  user
end

date = Date.new(2012,1,4)

time = Time.now.strftime("%Y%m%d%H%M%S")
save_path = Rails.root.join("tmp", "user_performance#{time}.csv")

CSV.open(save_path, "wb") do |csv|
  csv << ["username", "frequency", "incremental", "budget", "amount_spent", "percent_change"]
  [7,14,21,28].each do |frequency|
    [100].each do |budget|
      [budget].each do |incremental|
        user = create_test_user(budget, date, frequency, incremental)
        csv << [user.username, frequency, user.incremental, budget, user.portfolio_cost, user.portfolio_change]
      end
    end
  end
end