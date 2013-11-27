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
      QUANTIFIED_CHARS_SUB_MAP = QUANTIFIED_CHARS.each_with_object({}) do |(norm, quant), h|
        quant.each { |quantified| h[quantified] = norm }
      end

      def evaluate_metrical_presence(string)
        @metrical = string && string.match(QUANTIFIED_CHARS_REGEXP)
      end

      def metrical?
        @metrical
      end

      # without meter
      def wo_meter(string)
        string.gsub(QUANTIFIED_CHARS_REGEXP, QUANTIFIED_CHARS_SUB_MAP)
      end
    end
  end
end
