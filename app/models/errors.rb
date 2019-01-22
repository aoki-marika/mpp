require 'sinja'

class UnauthorizedError < Sinja::HttpError
    HTTP_STATUS = 401

    def initialize(*args) super(HTTP_STATUS, *args) end
end
