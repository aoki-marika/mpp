require 'sequel'

Model = Class.new(Sequel::Model)
class Model
    def api_data
    end

    def to_api
        data = api_data

        # most models return hashes of data that have subitems that need to be converted
        if data.is_a? Hash
            # automatically prepend the id to model api data
            { :id => @values[:id] }.merge(data).map do |k, v|
                if v.respond_to? 'to_api'
                    # use to_api when its implemented
                    [k, v.to_api]
                elsif v.is_a? Array
                    # map arrays and call to_api if its implemented, if not just return the item
                    [k, v.map { |i| (i.respond_to? 'to_api') ? i.to_api : i }]
                else
                    # fallback to returning the key and value, unmodified
                    [k, v]
                end
            end.to_h
        else
            # some models return a single piece of data, e.g. titles
            data
        end
    end
end
