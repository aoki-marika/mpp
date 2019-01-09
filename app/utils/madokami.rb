require 'net/http'
require 'uri'

class Madokami
    # Make a request to the given path on Madokami with the given credentials.
    # Yields the response when the request finishes.
    def self.request(path, username, password)
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
end
