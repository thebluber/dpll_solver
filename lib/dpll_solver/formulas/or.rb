module DpllSolver
  module Formulas
    class Or < BinaryFormula
      def to_s
        "(#{@f1.to_s} OR #{@f2.to_s})"
      end

      def clause?
        @f1.clause? && @f2.clause?
      end

      def min_term?
        false
      end

      alias cnf? clause?

      def or?
        true
      end

      def verum?
        false
      end
      alias falsum? verum?
      alias not? verum?
      alias and? verum?
      alias variable? verum?

      def simplify
        res_f1 = @f1.simplify
        res_f2 = @f2.simplify
        if res_f1.falsum? #identity
          return res_f2
        elsif res_f2.falsum? #identity
          return res_f1
        elsif res_f1.verum? || res_f2.verum? #anihilator
          return DpllSolver::Formulas::Verum
        elsif res_f1 == res_f2 #idempotence
          return res_f1
        else
          return self.class.new(res_f1, res_f2)
        end
      end

      def cnf
        if cnf?
          return self
        elsif nnf?
          if @f1.and?
            return DpllSolver::Formulas::And.new(self.class.new(@f1.f1, @f2).cnf, self.class.new(@f1.f2, @f2).cnf)
          elsif @f2.and?
            return DpllSolver::Formulas::And.new(self.class.new(@f1, @f2.f1).cnf, self.class.new(@f1, @f2.f2).cnf)
          else
            return self.class.new(@f1.cnf, @f2.cnf).cnf
          end
        else
          return nnf.cnf
        end
      end

    end
  end
end
