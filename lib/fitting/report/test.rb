module Fitting
  module Report
    class Test
      def initialize(test)
        @test = test
        @prefix = false
        @action = false
        @response = false
        @combination = false
        @id = SecureRandom.hex
      end

      attr_reader :id

      def to_h
        {
          path: path,
          method: method,
          status: status,
          body: body
        }
      end

      def path
        @test['path']
      end

      def method
        @test['method']
      end

      def status
        @test['response']['status'].to_s
      end

      def body
        @test['response']['body']
      end

      def mark_prefix
        @prefix = true
      end

      def mark_action
        @action = true
      end

      def mark_response
        @response = true
      end

      def mark_combination
        @combination = true
      end

      def there_a_prefix?
        @prefix
      end

      def there_an_actions?
        @action
      end

      def there_an_responses?
        @response
      end

      def there_an_combinations?
        @combination
      end
    end
  end
end
