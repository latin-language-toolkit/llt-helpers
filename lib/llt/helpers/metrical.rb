module LLT
  module Helpers
    module Metrical
      QUANTIFIED_CHARS = {
        'a' => ['ă', 'ā'],
        'e' => ['ĕ', 'ē'],
        'i' => ['ĭ', 'ī'],
        'o' => ['ŏ', 'ō'],
        'u' => ['ŭ', 'ū'],
        'y' => ['ў', 'ȳ'],
      }
      QUANTIFIED_CHARS_REGEXP = /[#{QUANTIFIED_CHARS.values.flatten.join}]/

      def evaluate_metrical_presence(string)
        @metrical = string && string.match(QUANTIFIED_CHARS_REGEXP)
      end

      def metrical?
        @metrical
      end
    end
  end
end
