class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    begin
      client = Polygonio::Rest::Client.new(Rails.application.credentials.polygon_io[:api_key])

      company = client.reference.tickers.details(ticker_symbol)
    
      # End-of-day price retrieval
      # The gem has a bug where 'volume' is expected to be an integer, but a float is returned.
      # See the monkey patch in initializer/polygonio_patch.rb for the fix.
      # 
      # Note: Cannot use `last_quote` due to restrictions in the free subscription plan.
      yesterday = yesterday_last_business_date(Date.today).strftime('%Y-%m-%d')
      daily_open_close = client.stocks.daily_open_close(ticker_symbol, yesterday)

      new(ticker: ticker_symbol, name: company.name, last_price: daily_open_close.close)
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  private 

  def self.yesterday_last_business_date(date = Date.today)
    case date.wday
    when 1 # Monday
      date - 3
    when 0 # Sunday
      date - 2
    else
      date - 1
    end
  end
end
