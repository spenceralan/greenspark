class Algorithm
  attr_accessor :user
  attr_accessor :budget
  attr_accessor :goal

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
    self.goal += user.incremenal
    change_goal if increase_goal?
  end

  def stocks_less_than_goal
    user.stocks.find_all do |stock|
      stock.value < goal
    end
  end

  def stocks_within_budget
    user_budget = budget
    stocks_to_purchase = []
    stocks_less_than_goal.each do | stock |
      value = stock.value
      how_many_to_buy = {stock: stock, quantity: 0}
      while value < goal
        while how_many_to_buy[:stock].last_updated_price * how_many_to_buy[:quantity] < user_budget
          user_budget -= stock.last_updated_price
          value += stock.last_updated_price
          how_many_to_buy[:quantity] += 1
        end
      end
      stocks_to_purchase.push(how_many_to_buy)
    end
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
