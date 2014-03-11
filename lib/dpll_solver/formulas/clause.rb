module DpllSolver
  module Formulas
    class Clause
      attr_accessor :literals
      def initialize(*args)
        @literals = Set.new(args)
      end

      def add(literal)
        @literals.add(literal)
        self
      end

      def delete(literal)
        literal_array = @literals.to_a
        literal_array.delete(literal)
        @literals = Set.new(literal_array)
        self
      end

      def unit?
        @literals.count == 1
      end

      def empty?
        @literals.empty?
      end

      def include?(literal)
        @literals.to_a.include?(literal)
      end

      def union(other)
        @literals = @literals + other.literals
        self
      end

      def get_unit_literal
        @literals.first if unit?
      end

      def ==(other)
        other.class == self.class && other.literals == @literals
      end

      def to_s
        "{#{@literals.to_a.map(&:to_s).join(', ')}}"
      end
      alias eql? ==
    end
  end
end
