require 'sequel'

require_relative 'token.rb'
require_relative '../utils/madokami.rb'

class User < Sequel::Model
    one_to_many :tokens

    # Try to get a `Token` for a user with the given username and password.
    # Registers the user if the credentials are valid and they aren't already registered.
    # Cleans out expired tokens for the user if they are already registered when checking for existing tokens.
    def self.get_token(username, password)
        # get the user for the given credentials
        user = User.first(name: username)

        # if the user is already registered
        if user != nil
            # remove expired tokens
            Token.remove_expired(user)

            # return the first unexpired token for the user, if it exists
            if existing_token = user.tokens.first
                return existing_token
            end
        end

        # the user either isnt registered or has no valid tokens, so try to get a new token
        Madokami.request '/login', username: username, password: password do |r|
            case r.code
                # '/login' redirects to '/' on successful authentication
                when '302'
                    cookie = r['Set-Cookie']

                    # parse the token and expiration date from the cookie
                    value = cookie.match(/(?:(remember_.+?=)).+?(?=;)/)[0]
                    expiration = Time.parse(cookie.match(/(?<=expires=).+?(?=;)/)[0].sub('GMT', 'UTC'))

                    # register the user if they arent already
                    if user == nil
                        user = User.create(name: username, password: password)
                    end

                    # insert the new token into the db
                    Token.create(user_id: user.id, value: value, expiration: expiration)
                else
                    raise UnauthorizedError.new
            end
        end
    end
end
