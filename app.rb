require "sinatra"
require "sinatra/reloader"
require "http"



def get_currencies
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  data = HTTP.get(api_url)
  parsed_data = JSON.parse(data)
  currencies = parsed_data.fetch("currencies")
  return currencies
end

get("/") do
  @currencies = get_currencies
  erb(:first_currency)
end

get("/:first_currency") do 
  @currencies = get_currencies
  @first_currency = params.fetch("first_currency")
  erb(:second_currency)
end

get("/:first_currency/:second_currency") do
  @first_currency = params.fetch("first_currency")
  @second_currency = params.fetch("second_currency")
  exchange_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@first_currency}&to=#{@second_currency}&amount=1"
  exchange_data = HTTP.get(exchange_url)
  parsed_exchange_data = JSON.parse(exchange_data)
  @result = parsed_exchange_data.fetch("result")
  erb(:convert)
end
