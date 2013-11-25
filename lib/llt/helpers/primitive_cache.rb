require 'dalli'

module LLT
  module Helpers
    module PrimitiveCache
      def self.included(obj)
        obj.extend(ClassMethods)
      end

      def enable_cache
        @cache_enabled = true
      end

      def disable_cache
        @cache_enabled = false
      end

      def cache
        self.class.cache
      end

      def cached(key)
        if @cache_enabled
          self.class.cache.fetch(key) { yield } #[key] ||= yield # with Dalli use
        else
          yield
        end
      end

      module ClassMethods
        def cache
          @cache ||= Dalli::Client.new # {}
        end
      end
    end
  end
end
