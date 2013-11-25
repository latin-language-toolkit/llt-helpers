module LLT
  module Helpers
    module Positions
      # Adds Comparable-like methods and more to an object, that holds an instance variable @position
      # While the Comparable module itself could be included, defining these methods manually comes with
      # a significant performance gain.

      def === other
        @position == other.position
      end

      def < other
        @position < other.position
      end

      def > other
        @position > other.position
      end

      def >= other
        @position >= other.position
      end

      def <= other
        @position >= other.position
      end

      def <=> other
        @position <=> other.position
      end

      def - other   # used by Rating
        @position - other.position
      end

      def surrounding
        [@position - 1, @position + 1]
      end

      def distance_to(other, absolute = false)
        d = other - self
        absolute ? d.abs : d
      end

      def nearest_in(arr)
        arr.sort_by { |el| distance_to(el, true) }.first
      end

      def in_front_of?(other, steps = 1)
        (other - self).between?(1, steps + 1)
      end

      def next_in(arr, &blk)
        arr.next_elem(self, &blk)
      end

      def prev_in(arr, &blk)
        arr.prev_elem(self, &blk)
      end

      def at_sentence_start(sos)
        @position == sos || @position == sos + 1
      end

      def in_front_of_any?(arr, steps = 1)
        arr.any? { |e| self.in_front_of?(e, steps) }
      end

      def behind_any?(arr, steps = 1)
        arr.any? { |e| self.behind?(e, steps) }
      end

      def behind?(other, steps = 1)
        (self - other).between?(1, steps + 1)   # (self - other) < steps + 1 not valid => true for negatives!
      end

      def close_to?(other, steps = 1)
        (self - other).abs < steps + 1
      end

      def between? a, b
        @position.between?(a.position, b.position)
      end

      def range_with(other, to_range = false)
        a, b = [@position, other.position].sort

        range = ((a + 1)...b)
        to_range ? range : range.to_a
      end
    end
  end
end
