module DpllSolver
  module Formulas
    class Not
      attr_accessor :f

      def initialize(f)
        @f = f
      end

      def ==(other)
        other.class == self.class && other.f == @f
      end

      alias eql? ==

      def to_s
        "-#{@f.to_s}"
      end

      def literal?
        @f.atomic_formula?
      end

      def atomic_formula?
        false
      end
      alias :nnf? :literal?
      alias :clause? :literal?
      alias :min_term? :literal?
      alias :cnf? :nnf?
      alias :dnf? :nnf?

      def not?
        true
      end

      def verum?
        false
      end
      alias falsum? verum?
      alias and? verum?
      alias or? verum?
      alias variable? verum?

      def simplify
        result = @f.simplify
        if result.not?
          result = result.f.simplify
        elsif result.verum?
          result = DpllSolver::Formulas::Falsum
        elsif result.falsum?
          result = DpllSolver::Formulas::Verum
        else
          result = self.class.new(result)
        end
        result
      end

      def nnf
        if @f.and? || @f.or?
          return apply_DeMorgan.nnf
        elsif @f.not?
          return @f.f.nnf
        else
          return self
        end
      end

      def cnf
        nnf? ? self : nnf.cnf
      end

      def apply_DeMorgan
        if @f.and?
          return DpllSolver::Formulas::Or.new(self.class.new(@f.f1), self.class.new(@f.f2))
        elsif @f.or?
          return DpllSolver::Formulas::And.new(self.class.new(@f.f1), self.class.new(@f.f2))
        else
          raise ArgumentError, 'DeMorgan can not be applied unless @f is either AND or OR'
        end
      end
    end
  end
end
