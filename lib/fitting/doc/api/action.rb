require 'fitting/doc/api/action'
require 'fitting/doc/api/response'

module Fitting
  class Doc
    class Api
      class Action
        def initialize(action)
          @action = action
          @responses = Fitting::Doc::Api::Response.new(@action.responses)
          @cover = false
        end

        def find!
          nil
        end

        def cover?
          @cover
        end

        def cover!
          @cover = true
        end

        def method
          @action.method
        end

        def path
          @action.path.to_s
        end

        attr_reader :responses, :tests

        def path_match(find_path)
          regexp =~ find_path
        end

        def regexp
          return @regexp if @regexp

          str = Regexp.escape(path)
          str = str.gsub(/\\{\w+\\}/, '[^&=\/]+')
          str = "\\A#{str}\\z"
          @regexp = Regexp.new(str)
        end
      end
    end
  end
end