require 'dry-struct'

module Types
  include Dry.Types()
end

# Define a patched response class with correct types
class PatchedDailyOpenCloseResponse < Dry::Struct
  attribute :status, Types::String
  attribute :symbol, Types::String
  attribute :open, Types::JSON::Decimal
  attribute :high, Types::JSON::Decimal
  attribute :low, Types::JSON::Decimal
  attribute :close, Types::JSON::Decimal
  attribute :volume, Types::Float
  attribute :after_hours, Types::JSON::Decimal
  attribute :from, Types::JSON::DateTime
end

# Override the method in the module
module PolygonioPatch
  def daily_open_close(symbol, date)
    symbol = Types::String[symbol]
    date = Types::JSON::Date[date]

    res = client.request.get("/v1/open-close/#{symbol}/#{date}")

    # Symbolize keys and fix naming inconsistencies
    formatted_data = res.body.transform_keys(&:to_sym)

    # Fix keys that are different in API response
    formatted_data[:after_hours] = formatted_data.delete(:afterHours) if formatted_data.key?(:afterHours)
    formatted_data[:pre_market] = formatted_data.delete(:preMarket) if formatted_data.key?(:preMarket)
    
    PatchedDailyOpenCloseResponse[formatted_data]
  end
end

# Apply the patch
Polygonio::Rest::Stocks.prepend(PolygonioPatch)
