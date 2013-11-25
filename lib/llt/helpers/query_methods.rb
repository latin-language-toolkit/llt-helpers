module LLT
  module Helpers
    module QueryMethods
      def add_query_methods_for(key_term, use: nil, delegate_to: nil)
        raise ArgumentError, "Can't use :use and :delegate_to together" if use && delegate_to

        meths = t.values_for(key_term)
        used_var = use || "@#{key_term}"
        meths.each do |meth|
          body = if delegate_to
                   "#{delegate_to}.#{meth}?"
                 else
                   "#{used_var} == :#{t.value_for(key_term, meth)}"
                 end

          class_eval <<-STR
            def #{meth}?
              #{body}
            end
          STR
        end
      end

      private
      def t
        Terminology
      end
    end
  end
end
