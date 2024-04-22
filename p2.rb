require 'httparty'
require 'json'

class CurrencyConverter
  include HTTParty

  base_uri 'https://v6.exchangerate-api.com/v6'

  def initialize(api_key)
    @api_key = api_key
  end

  def convert(amount, from_currency, to_currency)
    response = self.class.get("/#{@api_key}/latest/#{from_currency}")
    if response.code == 200
      json_response = JSON.parse(response.body)
      exchange_rate = json_response['conversion_rates'][to_currency]
      converted_amount = amount * exchange_rate
      "#{amount} #{from_currency} is equal to #{converted_amount.round(2)} #{to_currency}"
    else
      "Error: #{response.code} - #{response.message}"
    end
  rescue StandardError => e
    "An error occurred: #{e.message}"
  end
end

api_key = '3c205824879cf78103495b5d'
currency_converter = CurrencyConverter.new(api_key)

amount = 100
from_currency = 'USD'
to_currency = 'EUR'

puts currency_converter.convert(amount, from_currency, to_currency)
