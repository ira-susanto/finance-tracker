class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    quote = Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote
    quote.price
  end
end
