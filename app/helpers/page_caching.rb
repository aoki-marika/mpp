require_relative '../models/archive.rb'

module PageCachingHelper
    # Get the include name for archives in this controller.
    # Should be overriden by controllers using this helper.
    def get_include
    end

    # Cache the archives for the given model, using the include path from `get_include`.
    # todo: concurrent caching requests? would be faster
    def cache_archives(model)
        # the include path for getting archives from model
        include = get_include

        if include != nil
            # get the type for model
            type = JSONAPI::Serializer.find_serializer(model, {}).type.to_s

            # remove the type from the beginning of include, if it exists
            # this handles cases like `/series/[id]/paths?include=archives`
            include.sub! /^#{Regexp.quote(type)}\.?/, ''
            include = nil if include == ''
        end

        if model.is_a?(Archive)
            # model is already an archive
            model.cache_pages(@token)
        elsif params[:include].any? { |i| i.start_with?(include) }
            # Traverse through a model to get the archives from its values.
            # `components` should be the include path, split on each `.`.
            # `index` should be the index in `components` the next model's path is at.
            def traverse(model, components, index)
                if index < components.length
                    # get the model for the current component
                    model = model.instance_eval(components[index])

                    if model.respond_to? 'each'
                        # the model is most likely an array, traverse through all its items
                        model.each do |i|
                            traverse(i, components, index + 1)
                        end
                    else
                        # the model is a singular item, traverse through the next component on the same model
                        traverse(model, components, index + 1)
                    end
                else
                    # the model at the end of components should always be an archive
                    model.cache_pages(@token)
                end
            end

            # begin traversing the model
            traverse(model, include.split('.'), 0)
        end
    end

    def serialize_model(model = nil, options = {})
        cache_archives(model)
        super
    end

    def serialize_models(models = [], options = {}, pagination = nil)
        models.each { |m| cache_archives(m) }
        super
    end
end
