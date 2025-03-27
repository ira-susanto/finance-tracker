class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    company = Alphavantage::Fundamental.new(symbol: ticker_symbol).overview
    quote = Alphavantage::TimeSeries.new(symbol: ticker_symbol).quote

    new(ticker: ticker_symbol, name: company.name, last_price: quote.price)
  end
end
