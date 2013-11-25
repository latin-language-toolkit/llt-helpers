module LLT
  module Helpers
    module Pluralize
      def pluralize(count, sg, pl = nil)
        if count == 1
          sg
        else
          pl || build_plural(sg)
        end
      end

      private

      def build_plural(sg)
        sg = sg.clone
        case sg
        when /y$/ then sg.chop << "ies"
        else sg << "s"
        end
      end
    end
  end
end
