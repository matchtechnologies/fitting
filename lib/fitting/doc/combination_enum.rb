require 'fitting/doc/combination_step'
require 'fitting/cover/json_schema_enum'

module Fitting
  class Doc
    class CombinationEnum < CombinationStep
      def cover!(log)
        error = JSON::Validator.fully_validate(@json_schema, log.body)
        if error == []
          @step_cover_size += 1
          @logs.push(log.body)
          nil
        else
          bodies = custom_body(log.body)
          errors = []
          bodies.each do |body|
            error = JSON::Validator.fully_validate(@json_schema, body)
            if error == []
              @step_cover_size += 1
              @logs.push(body)
              nil
            else
              errors.push(
                {
                  combination: @step_key,
                  type: @type,
                  json_schema: @json_schema,
                  error: error,
                  body: body
                })
            end
          end

          if errors.size == bodies.size
            errors
          else
            nil
          end
        end
      end

      def find_keys
        new_keys = []
        if YAML.dump(@json_schema).include?("array")
          res = @json_schema
          @step_key.split('.').each do |key|
            if res[key].class == Hash && res[key] != nil
              if res[key].class == Hash && res[key]['type'] == 'array'
                new_keys.push(key)
                return new_keys
              else
                if key != 'properties'
                  new_keys.push(key)
                end
                res = res[key]
              end
            end
          end
        end
        []
      end

      def custom_body(body)
        bodies = []
        keys = find_keys
        if keys != []
          if keys.size == 1
            if body[keys[0]].size == 1
              return body
            else
              body[keys[0]].each do |bb|
                new_body = body.dup
                new_body.delete(keys[0])
                bodies.push(new_body.merge(keys[0] => bb))
              end
            end
          end
          return bodies
        end
        [body]
      end

      def report(res, index)
        @index_before = index
        @res_before = [] + res
        @index_medium = index
        @res_medium = [] + res

        combinations = @step_key.split('.')
        elements = YAML.dump(@source_json_schema).split("\n")[1..-1]

        res_index = 0
        element_index = 0
        elements.each_with_index do |element, i|
          if element.include?(combinations[element_index])
            element_index += 1
          end
          if combinations.size == element_index
            res_index = i
            break
          end
        end
        res[res_index + index] = @step_cover_size
        @index_after = res_index + index
        @res_after = [] + res
        [res, index]
      end
    end
  end
end
