module Fitting
  class Statistics
    class Percent
      def initialize(divider, dividend)
        @divider = divider
        @dividend = dividend
      end

      def to_f
        return 0.to_f if @divider == 0
        (@dividend.to_f / @divider.to_f * 100.0).round(2)
      end
    end
  end
end
