module LLT
  module Helpers
    module Metrical
      QUANTIFIED_CHARS = /[ăāĕēĭīŏōŭūўȳ]/
      def evaluate_metrical_presence(string)
        @metrical = string && string.match(QUANTIFIED_CHARS)
      end

      def metrical?
        @metrical
      end
    end
  end
end
