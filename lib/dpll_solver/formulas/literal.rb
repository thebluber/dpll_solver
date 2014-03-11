module DpllSolver
  module Formulas
    class Literal
      attr_accessor :var, :phase
      def initialize(var, phase)
        @var   = var
        @phase = phase
      end

      def negate
        self.class.new(@var, !@phase)
      end

      def to_s
        phase ? @var.to_s : "-#{@var.to_s}"
      end

      def ==(other)
        other.class == self.class && other.var == @var && other.phase == @phase
      end

      alias eql? ==
    end
  end
end
