module LLT
  module Helpers
    # currently not used, implemented slightly differently in LLT::Service class
    module Configuration
      def self.included(obj)
        obj.extend(ClassMethods)
      end

      def configure(options = {})
        # It might appeal here to refactor this to us merge.
        # Don't do it: we don't want everything that might be present in options,
        # only what we use in the configuration. Cf. specs.
        configuration.each do |key, (val, _)|
          val = options[key] || val
          instance_variable_set("@#{key}", val)
        end
      end

      def configuration
        self.class.configuration
      end

      module ClassMethods
        def configuration
          @configuration ||= {}
        end

        def reload!
          configuration.each do |_, arr|
            arr[0] = arr[1].call
          end
        end

        def method_missing(meth, *args, &blk)
          if meth.to_s.match(/^uses_(.*)/)
            configuration[$1.to_sym] = [blk.call, blk]
          else
            super
          end
        end
      end
    end
  end
end
