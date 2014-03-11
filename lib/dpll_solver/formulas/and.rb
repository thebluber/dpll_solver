module DpllSolver
  module Formulas
    class And < BinaryFormula
      def to_s
        "(#{@f1.to_s} AND #{@f2.to_s})"
      end

      def clause?
        false
      end

      def min_term?
        @f1.min_term? && @f2.min_term?
      end

      def cnf?
        @f1.cnf? && @f2.cnf?
      end

      def and?
        true
      end

      def verum?
        false
      end
      alias falsum? verum?
      alias not? verum?
      alias or? verum?
      alias variable? verum?

      def simplify
        res_f1 = @f1.simplify
        res_f2 = @f2.simplify
        if res_f1.verum? #identity
          return res_f2
        elsif res_f2.verum? #identity
          return res_f1
        elsif res_f1.falsum? || res_f2.falsum? #anihilator
          return DpllSolver::Formulas::Falsum
        elsif res_f1 == res_f2 #idempotence
          return res_f1
        else
          return self.class.new(res_f1, res_f2)
        end
      end

      def cnf
        nnf? ? self.class.new(@f1.cnf, @f2.cnf) : nnf.cnf
      end

    end
  end
end
