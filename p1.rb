require 'httparty'
require 'json'

class WeatherDataAggregator
  include HTTParty

  base_uri 'http://api.openweathermap.org/data/2.5'

  def initialize(api_key)
    @api_key = api_key
  end

  def fetch_weather(city)
    response = self.class.get("/weather?q=#{city}&APPID=#{@api_key}&units=metric")
    if response.code == 200
      json_response = JSON.parse(response.body)
      temperature = json_response['main']['temp']
      humidity = json_response['main']['humidity']
      conditions = json_response['weather'][0]['description']
      { temperature: temperature, humidity: humidity, conditions: conditions }
    else
      puts "Error fetching weather data: #{response.code} - #{response.message}"
      nil
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
    nil
  end
end

api_key = 'e1dabad546b95fc084d2c0263556f64b'
weather_aggregator = WeatherDataAggregator.new(api_key)

city = 'London, UK'
current_weather = weather_aggregator.fetch_weather(city)
if current_weather
  puts "Current temperature in #{city}: #{current_weather[:temperature]}°C"
  puts "Current humidity in #{city}: #{current_weather[:humidity]}%"
  puts "Current weather conditions in #{city}: #{current_weather[:conditions]}"
else
  puts "Failed to fetch weather data for #{city}"
end
