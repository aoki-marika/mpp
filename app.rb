require 'sinatra'

configure :production, :development do
    enable :logging
end

get '/' do
    'Hello, world!'
end
