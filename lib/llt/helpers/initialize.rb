module LLT
  module Helpers
    module Initialize

      # Maps Hash keys to instance_variables
      #
      # Recommended usage is to implement #init_keys as an Array of Symbols
      # Example:
      # def init_keys
      #   %i{ type stem inflection_class }
      # end
      #
      # This will set @type, @stem and @inflection_class with their
      # corresponding values.
      # Keys not defined in init_keys or as param are untouched.
      def extract_args!(args, keys = init_keys)
        keys.each do |var_name|
          instance_variable_set("@#{var_name}", args[var_name])
        end
      end

      def extract_normalized_args!(args, keys = init_keys)
        args = Helpers::Normalizer.normalize_args(args)
        extract_args!(args, keys)
      end
    end
  end
end
