require 'sequel'

require_relative 'user.rb'

class Token < Sequel::Model
    many_to_one :user

    # Remove expired tokens from the database.
    # Removes only tokens for `user` if it is given.
    def self.remove_expired(user = nil)
        dataset = user != nil ? user.tokens_dataset : Token

        # token expiration times are stored in utc
        dataset.where { expiration <= Time.now.utc }.delete
    end
end
