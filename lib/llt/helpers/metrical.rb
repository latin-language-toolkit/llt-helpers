module LLT
  module Helpers
    module Metrical
      def evaluate_metrical_presence(string)
        @metrical = string && ! string.ascii_only?
      end

      def metrical?
        @metrical
      end
    end
  end
end
