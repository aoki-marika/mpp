require 'sinatra/base'
require 'net/http'
require 'uri'

module Routes
    class BaseController < Sinatra::Base
        configure :production, :development do
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
            halt json({ 'status': status_code, 'message': message });
        end

        # Make a request to the given path on Madokami with the given credentials.
        # Yields the response when the request finishes.
        def request_madokami(path, username, password)
            # get the uri to request
            uri = URI.join('https://manga.madokami.al/', path);

            # start an ssl connection
            Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
                # build the request with credentials
                request = Net::HTTP::Get.new(uri);
                request.basic_auth(username, password);

                # make the request and yield the response
                yield http.request(request);
            end
        end

        # verify credentials before every endpoint
        before do
            # placed here as its called in multiple places
            def invalid_credentials
                error('401', 'Invalid credentials.');
            end

            # get the basic auth from the request
            auth = Rack::Auth::Basic::Request.new(request.env);

            # verify that there is a valid username and password
            if auth.provided? and auth.basic? and auth.credentials
                username = auth.credentials.first
                password = auth.credentials.last

                # verify the credentials by requesting the madokami homepage
                request_madokami('/', username, password) { |response|
                    case response.code
                        when '200'
                            pass
                        when '401'
                            invalid_credentials();
                        when '408', '503'
                            error('503', 'Unable to connect to Madokami to verify credentials.');
                        else
                            logger.error("An unexpected error occured while verifying credentials.\n" \
                                         "Headers:\n" \
                                         "#{response.to_hash}\n" \
                                         "Body:\n" \
                                         "#{response.body}\n");

                            error('500', 'An unexpected error occured while verifying credentials.');
                    end
                }
            else
                # the basic auth credentials were invalid in some way
                invalid_credentials();
            end
        end
    end
end
