module TransactionsHelper

  def current_date
    Date.today.strftime("%Y-%m-%d")
  end

  def transaction_select_options(transaction_types)
    transaction_types.map do | type |
      [type.capitalize, type]
    end
  end

  def format_number(number)
    format("%0.2f", number)
  end

end
