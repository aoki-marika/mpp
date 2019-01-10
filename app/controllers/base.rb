require 'sinatra/base'

require_relative '../utils/madokami.rb'
require_relative '../models/user.rb'

class BaseController < Sinatra::Base
    configure :development, :production do
        enable :logging
        enable :dump_errors
    end

    # Prepares the response for a JSON body and returns the JSON representation of `value`.
    def json(value)
        content_type :json
        value.to_json
    end

    # Returns an error response with the given status code and message.
    def error(status_code, message)
        status status_code
        halt json({ 'status': status_code, 'message': message })
    end

    # verify credentials before every endpoint
    before do
        def invalid_credentials
            error '401', 'Invalid credentials.'
        end

        # get the basic auth from the request
        auth = Rack::Auth::Basic::Request.new(request.env)

        # verify that there is a valid username and password
        if auth.provided? and auth.basic? and auth.credentials
            username = auth.credentials.first
            password = auth.credentials.last

            # verify the credentials against the db if the user is already registered, else attempt to register them
            if (user = User.first(name: username)) != nil
                # the user is already registered, verify the password
                password == user.password ? pass : invalid_credentials
            else
                # verify for registration by checking the credentials against madokami
                Madokami.request('/', username, password) { |response|
                    case response.code
                        when '200'
                            # register the user
                            User.create(name: username, password: password)
                            pass
                        when '401'
                            invalid_credentials
                        when '408', '503'
                            error '503', 'Unable to connect to Madokami to verify credentials.'
                        else
                            logger.error "An unexpected error occured while verifying credentials.\n" \
                                         "Headers:\n" \
                                         "#{response.to_hash}\n" \
                                         "Body:\n" \
                                         "#{response.body}\n"

                            error '500', 'An unexpected error occured while verifying credentials.'
                    end
                }
            end
        else
            # the basic auth credentials were invalid in some way
            invalid_credentials
        end
    end
end

