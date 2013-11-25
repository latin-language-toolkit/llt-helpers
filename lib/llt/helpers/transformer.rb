module LLT
  module Helpers
    module Transformer
      def to_hash(custom: {}, whitelist: [], blacklist: [], root: false, keys: :to_sym)
        overwritten = custom.keys.map(&:to_sym)
        res = instance_variables.each_with_object({}) do |var, hash|
          sym = inst_to_sym(var)

          next if whitelist.any? && ! whitelist.include?(sym)
          next if blacklist.include?(sym)
          next if overwritten.include?(sym)

          hash[sym.send(keys)] = instance_variable_get(var)
        end

        res.merge!(custom)

        if root
          root = self.class.name if root == true
          { root => res }
        else
          res
        end
      end

      private

      def inst_to_sym(inst_var)
        inst_var.to_s.delete("@").to_sym
      end
    end
  end
end
