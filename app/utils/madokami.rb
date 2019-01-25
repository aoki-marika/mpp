require 'net/http'
require 'uri'

class Madokami
    # Make a request to the given path on Madokami with the given credentials.
    # If no token is given the authentication falls back to basic via username and password.
    # Yields the response when the request finishes.
    def self.request(path, token: nil, username: nil, password: nil)
        # get the uri to request
        uri = URI.join('https://manga.madokami.al/', path)

        # start an ssl connection
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
            # build the request with credentials
            request = Net::HTTP::Get.new(uri)

            if token != nil
                # use token auth if a token is given
                request['Cookie'] = token.value
            else
                # use basic auth when no token is given
                request.basic_auth(username, password)
            end

            # make the request and yield the response
            yield http.request(request)
        end
    end
end
