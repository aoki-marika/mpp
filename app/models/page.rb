class Page
    MAX_LIMIT = 50

    def initialize(model, page: 0, limit: MAX_LIMIT)
        @model = model

        # make sure page is above 0
        @page = [page, 0].max

        # make sure the limit is between 0 and MAX_LIMIT, and default to MAX_LIMIT if limit is 0
        @limit = [[limit, 0].max, MAX_LIMIT].min
        @limit = limit == 0 ? MAX_LIMIT : limit
    end

    def to_api
        items = @model.limit(@limit).offset(@page * @limit)

        # return nil if there are no items and its not the first page
        if items.count == 0 && @page > 0
            return nil
        end

        {
            :items => items.map { |m| (m.respond_to? 'to_api') ? m.to_api : m },
            :count => @model.count,
        }
    end
end
