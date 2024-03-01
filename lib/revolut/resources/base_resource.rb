module Revolut
  class BaseResource
    class << self
      def http_client
        @http_client ||= Revolut::Client.instance
      end

      def skip_coertion_for(attrs = [])
        @skip_coertion_for ||= attrs
      end

      def to_proc
        ->(attrs) { new(attrs) }
      end

      def not_allowed_to(attrs = [])
        @not_allowed_to ||= attrs
      end
    end

    def to_json
      @_raw.to_json
    end

    protected

    def initialize(attrs = {})
      @_raw = attrs

      attrs.each do |key, value|
        if self.class.skip_coertion_for.include?(key.to_sym)
          instance_variable_set(:"@#{key}", value)
        else
          coerced_value = if value.is_a?(Hash)
            Revolut::BaseResource.new(value)
          elsif value.is_a?(Array)
            value.map { |v| Revolut::BaseResource.new(v) }
          else
            value
          end
          instance_variable_set(:"@#{key}", coerced_value)
        end
      end

      instance_variables.each { |iv| self.class.send(:attr_accessor, iv.to_s[1..].to_sym) }
    end
  end
end
