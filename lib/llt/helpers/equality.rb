module LLT
  module Helpers
    module Equality

      # Intended to be uses as Class Extension.
      # Responds to class methods in form of
      # .equality_of_***_defined_by and takes several
      # params, which define equality operators for the
      # classes instance.
      # These instances then respond to #same_***_as?(object).
      def method_missing(meth, *args, &blk)
        if meth.to_s.match(/^equality_of_(.*)_defined_by/)
          equality_definition = "equality_definition_for_#{$1}"
          define_method(equality_definition) do
            args.map { |arg| send(arg) }
          end

          equality_comparator = "same_#{$1}_as?"
          define_method(equality_comparator) do |other|
            send(equality_definition) == other.send(equality_definition)
          end
        else
          super
        end
      end
    end
  end
end
