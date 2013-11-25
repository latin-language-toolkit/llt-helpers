module LLT
  module Helpers
    module Constantize
      def constant_by_type(type = @type, prefix: "", suffix: "", namespace: LLT)

        raise ArgumentError.new("type cannot be nil") if type.nil?

        t = begin
              Terminology.send(type, :full)
            rescue
              type
            end
        scope = namespace || self.class
        arg = "#{classified(prefix)}#{classified(t)}#{classified(suffix)}"
        scope.const_get(arg)
      end

      private

      def classified(arg)
        arg.to_s.split("_").map(&:capitalize).join
      end
    end
  end
end
