module Utilities
    module Filesystem
        def self.absolute_path(base, path)
            File.expand_path(File.join(File.dirname(File.expand_path(base)), path));
        end
    end
end
