require 'net/http'
require 'uri'
require 'erb'

require_relative '../models/errors.rb'

class Madokami
    # Get the URI for `path` on Madokami.
    def self.get_uri(path)
        URI.join('https://manga.madokami.al/', path)
    end

    # Encode a path for usage in a URI on Madokami.
    def self.encode_path(path)
        ERB::Util.url_encode(path)
    end

    # Make a request to the given path on Madokami with the given credentials.
    # If no token is given the authentication falls back to basic via username and password.
    # Yields the response when the request finishes.
    def self.request(path, token: nil, username: nil, password: nil)
        # get the uri to request
        uri = self.get_uri(path)

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

    # Make a request to get the pages for an archive.
    def self.get_pages(archive_path, token)
        # for whatever reason madokami double encodes paths in reader urls
        path = "/reader/#{self.encode_path(self.encode_path(archive_path))}"

        # todo: some images are out of order
        # e.g. 521295 (bokura no hentai v04) has `__cover2.jpg` at the end instead of beginning

        # make the reader request
        self.request path, token: token do |r|
            case r.code
                when '200'
                    # parse out the files array
                    files = r.body.match(/(?<=data-files="\[).+?(?=\]")/)[0].split(',')

                    # cleanup all the filenames and map them to an array of hashes
                    files.map.with_index do |f, i|
                        f.gsub! '&quot;', ''
                        f.gsub! '\\/', '/'

                        { :path => f, :index => i }
                    end
                else
                    raise UnauthorizedError.new
            end
        end
    end
end
