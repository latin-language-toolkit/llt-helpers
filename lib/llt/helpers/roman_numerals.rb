require 'llt/constants/numerals'

module LLT
  module Helpers
    module RomanNumerals

      # Primitive implementation to detect and convert Roman Numerals.

      class << self

        # Uncapitalized numerals will NOT be detected atm.
        def roman?(value)
          /^[CDILMVX]*$/.match(value)
        end

        # 4 to IV
        def to_roman(value)
          res = ""
          numerals.each do |dec, _|
            while value >= dec
              value -= dec
              res << numerals[dec]
            end
          end

          res
        end

        # IV to 4
        def to_decimal(value)
          res = 0
          numerals.each do |_, rom|
            while value.start_with?(rom)
              value = value[rom.length..-1]
              res += numerals.key(rom)
            end
          end

          res
        end

        private

        def numerals
          LLT::Constants::NUMERALS
        end
      end
    end
  end
end
