require 'httparty'
require 'json'

class EventFinder
  include HTTParty

  base_uri 'https://app.ticketmaster.com/discovery/v2'

  def initialize(api_key)
    @api_key = api_key
  end

  def find_events(location)
    response = self.class.get("/events.json",
                               query: { apikey: @api_key, city: location })


    if response.code == 200

      events = JSON.parse(response.body)['_embedded']['events']
      events.map do |event|
        {
          name: event['name'],
          venue: event['_embedded']['venues'][0]['name'],
          date: event['dates']['start']['localDate'],
          time: event['dates']['start']['localTime']
        }
      end
    else
      puts "Error: #{response.code} - #{response.message}"
      []
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
    []
  end
end

# Replace 'YOUR_API_KEY' with the provided API key
api_key = 'uPC5ZkivkUeujxfwTYa0xzW5dcOFeRrN'
event_finder = EventFinder.new(api_key)

location = 'Chicago' # Specify the location to search for events
events = event_finder.find_events(location)
if events.any?
  puts "Upcoming events in #{location}:"
  events.each do |event|
    puts "Name: #{event[:name]}"
    puts "Venue: #{event[:venue]}"
    puts "Date: #{event[:date]}"
    puts "Time: #{event[:time]}"
    puts "-" * 20
  end
else
  puts "No events found in #{location}"
end
 