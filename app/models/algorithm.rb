class Algorithm
  attr_accessor :user
  attr_accessor :budget
  attr_accessor :goal
  attr_accessor :total

  def initialize(user, budget)
    self.user = user
    self.budget = budget
    self.goal = user.incremental

    change_goal if increase_goal?
  end

  def stock_quantities_to_meet_goal
    quantities = []
    stocks_less_than_goal.each do | stock |
      quantities.push(
        {
          stock: stock,
          quantity: quantity_to_exceed_goal(stock)
        }
      )
    end
    quantities
  end

  def increase_goal?
    stocks_less_than_goal.empty?
  end

  def change_goal
    self.goal += user.incremental
    change_goal if increase_goal?
  end

  def stocks_less_than_goal
    user.stocks.find_all do |stock|
      stock.value < goal
    end
  end

  def sorted_by_performance(stocks)
    stocks.sort_by { |stock| stock.change }
  end

  def stocks_within_budget
    user_budget = budget
    stocks_to_purchase = []
    sorted_stocks = sorted_by_performance(stocks_less_than_goal)
    sorted_stocks.each do | stock |
      value = stock.value
      how_many_to_buy = {stock: stock, quantity: 0}
      while how_many_to_buy[:stock].last_updated_price < user_budget && value < goal
        user_budget -= stock.last_updated_price
        value += stock.last_updated_price
        how_many_to_buy[:quantity] += 1
      end
      stocks_to_purchase.push(how_many_to_buy) if how_many_to_buy[:quantity] > 0
    end
    self.total = budget - user_budget
    stocks_to_purchase
  end

  def quantity_to_exceed_goal(stock)
    quantity = 0
    cost = 0
    while cost <= goal
      cost += stock.last_updated_price
      quantity += 1
    end
    quantity
  end
end
