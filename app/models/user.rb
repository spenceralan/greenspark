class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  DEFAULT_INCREMENTAL = 100.00

  attr_accessor :login

  has_many :stocks, dependent: :destroy
  has_many :transactions

  after_initialize :init

  after_create :default_stocks

  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }

  validate :validate_username

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def portfolio_value
    value = 0
    stocks.each do |stock|
      value += stock.value
    end
    value
  end

  def portfolio_cost
    cost = 0
    stocks.each do |stock|
      cost += stock.cost
    end
    cost
  end

  def portfolio_change
    return 0 if portfolio_cost == 0
    percent = ((portfolio_value - portfolio_cost) / portfolio_cost) * 100
    percent.round(2)
  end

private

  def init
    self.incremental ||= DEFAULT_INCREMENTAL
  end

  def default_stocks
    self.stocks.create([
      {
        name: "PowerShares WilderHill Clean Energy Portfolio",
        symbol: "PBW",
        description: "The investment seeks investment results that generally correspond (before fees and expenses) to the price and yield of the WilderHill Clean Energy Index. The fund generally will invest at least 90% of its total assets in common stocks of companies that comprise the underlying index. The underlying index was composed of the stocks of about 40 companies that are publicly traded in the United States and that are engaged in the business of the advancement of cleaner energy and conservation.",
        exchange: "NAR",
      },
      {
        name: "First Trust Global Wind Energy ETF",
        symbol: "FAN",
        description: "The investment seeks investment results that correspond generally to the price and yield (before the fund's fees and expenses) of an equity index called the ISE Clean Edge Global Wind Energy Index. The fund will normally invest at least 90% of its net assets (including investment borrowings) in common stocks or in depositary receipts representing securities in the index. The index provides a benchmark for investors interested in tracking public companies throughout the world that are active in the wind energy industry based on analysis of the products and services offered by those companies. The fund is non-diversified.",
        exchange: "NAR",
      },
      {
        name: "iShares Global Clean Energy ETF",
        symbol: "ICLN",
        description: "The investment seeks to track the S&P Global Clean Energy IndexTM. The fund generally invests at least 90% of its assets in the component securities of the index and in investments that have economic characteristics that are substantially identical to the component securities and may invest up to 10% of its assets in certain futures, options and swap contracts, cash and cash equivalents, as well as in securities not included in the index. The index is designed to track the performance of approximately 30 of what are will be the most liquid and tradable securities of global companies involved in clean energy related businesses. The fund is non-diversified.",
        exchange: "NASDAQ",
      },
      {
        name: "Guggenheim Solar ETF",
        symbol: "TAN",
        description: "The investment seeks investment results that correspond generally to the performance, before the fund's fees and expenses, of an equity index called the MAC Global Solar Energy Index. The fund will invest at least 90% of its total assets in common stock, ADRs and GDRs that comprise the index and depositary receipts representing common stocks included in the index. The index is comprised of equity securities, including ADRs and GDRs, traded in developed markets. The fund is non-diversified.",
        exchange: "NAR",
      },
      {
        name: "PowerShares WilderHill Progressive Energy Portfolio",
        symbol: "PUW",
        description: "The investment seeks investment results that generally correspond (before fees and expenses) to the price and yield of the WilderHill Progressive Energy Index. The fund generally will invest at least 90% of its total assets in common stocks that comprise the underlying index. The underlying index was composed of common stocks of about 40 companies that are publicly traded in the United States and are engaged in a business or businesses that the index provider believes may substantially benefit from a societal shift toward the transitional energy technologies significant in improving the use of fossil fuels and nuclear power.",
        exchange: "NAR",
      },
      {
        name: "First Trust NASDAQ Clean Edge Green Energy Index Fund",
        symbol: "QCLN",
        description: "The investment seeks investment results that correspond generally to the price and yield (before the fund's fees and expenses) of an equity index called the NASDAQ Clean Edge Green Energy IndexSM. The fund will normally invest at least 90% of its net assets (including investment borrowings) in common stocks that comprise the index. The index is a modified market capitalization-weighted index in which larger companies receive a larger index weighting and includes caps to prevent high concentrations among larger alternative energy stocks. It is non-diversified.",
        exchange: "NASDAQ",
      },
      {
        name: "PowerShares Cleantech Portfolio ETF",
        symbol: "PZD",
        description: "The investment seeks investment results that generally correspond (before fees and expenses) to the price and yield of the Cleantech IndexTM. The fund generally will invest at least 90% of its total assets in stocks of clean technology (or 'cleantech') companies that comprise the underlying index and American depositary receipts ('ADRs') based on the stocks in the underlying index. The underlying index is a modified equally weighted index currently comprised of stocks of publicly traded cleantech companies and ADRs on such stocks.",
        exchange: "NAR",
      },
      {
        name: "VanEck Vectors Global Alternative Energy ETF",
        symbol: "GEX",
        description: "The investment seeks to replicate as closely as possible, before fees and expenses, the price and yield performance of the Ardour Global IndexSM (Extra Liquid). The fund normally invests at least 80% of its total assets in stocks of companies primarily engaged in the business of alternative energy. Such companies may include small- and medium-capitalization companies and foreign issuers. Alternative energy refers to the generation of power through environmentally friendly, non traditional sources. It is non-diversified.",
        exchange: "NAR",
      },

    ])
  end
end
