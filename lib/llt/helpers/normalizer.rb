module LLT
  module Helpers
    module Normalizer
      def normalize_args(args)
        args.each_with_object({}) do |(orig_k, v), hash|
          if orig_k == :options
            hash[orig_k] = normalize_args(v)
          else
            norm_k = terminology.key_term_for(orig_k)
            if norm_k
              hash[norm_k] = terminology.value_term_for(norm_k, v)
            else
              key = (orig_k =~ /^(stem|persona|place|options)$/ ? orig_k.to_sym : orig_k)
              hash[key] = v
            end
          end
        end
      end

      def terminology
        Terminology
      end
      alias :t :terminology

      extend self
    end
  end
end
