module Fitting
  class Cover
    class JSONSchemaOneOf
      attr_reader :json_schema, :combinations

      def initialize(json_schema)
        @json_schema = json_schema
        @combinations = []
      end

      def combi
        inception(json_schema, combinations).each do |combination|
          combination[0] = combination[0]
          combination[1] = ['one_of', combination[1]]
        end
      end

      def inception(json_schema, combinations)
        json_schema.each do |key, value|
          if key == 'oneOf'
            schema = json_schema.dup
            one_of = schema.delete('oneOf')
            one_of.each_index do |index|
              schema_new = json_schema.dup
              schema_new.delete('oneOf')
              combinations.push([schema_new.merge(one_of[index]), "oneOf.#{index}"])
            end
          elsif value.is_a?(Hash)
            com = inception(value, [])
            com.each do |combination|
              combination[0] = { key => value.merge(combination[0]) }
              combination[1] = "#{key}.#{combination[1]}"
            end
            combinations += com
          end
        end

        combinations
      end
    end
  end
end
