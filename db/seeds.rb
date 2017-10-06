# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



def create_test_user(budget, start_date, frequency)

  User.find_by(username: "testuser#{budget}#{frequency}")&.destroy

  if budget > 100
    incremental = budget
  else
    incremental = 100
  end

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
  
    stocks_to_buy = Algorithm.new(user, budget)
  
    stocks_to_buy.stocks_within_budget.each do |stock|
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

end

date = Date.new(2012,1,4)

create_test_user(50, date, 14)
create_test_user(100, date, 7)
create_test_user(500, date, 28)
create_test_user(1000, date, 28)