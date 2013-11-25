module LLT
  module Helpers
    module Functions

      # Objects that use this module must implement #functions,
      # which shall respond to #include?
      def has_function?(function)
        functions.include?(function)
      end

      def has_not_function? function
        ! has_function?(function)
      end

      # Shortcut methods
      def has_f?(function)
        # Do not alias or delegate.
        #
        # It's (slightly) faster that way and this method will usually
        # get lots of calls.
        functions.include?(function)
      end
      alias :has_not_f? :has_not_function?
    end
  end
end
