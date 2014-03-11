module DpllSolver
  module Parsers
    class Grammar < Parslet::Parser
      root :formula
      rule(:formula) { falsum.as(:falsum) | verum.as(:verum) | variable.as(:var) | not_operation.as(:not) | and_operation.as(:and) | or_operation.as(:or) }
      rule(:space) { str(" ").maybe }
      rule(:verum) { match('[1T]') }
      rule(:falsum) { match('[0F]') }
      rule(:variable) { match('[a-z]') >> match('[0-9]').repeat(0,3) }
      rule(:not_operation) { str("-") >> formula.as(:root_formula) }
      rule(:or_operation) { str("(") >> formula.as(:left) >> space >> (match('[+|]') | str('OR')) >> space >> formula.as(:right) >> str(")") }
      rule(:and_operation) { str("(") >> formula.as(:left) >> space >> (match('[*&]') | str('AND')) >> space >> formula.as(:right) >> str(")") }
    end

    class Transformer < Parslet::Transform
      rule(:verum => simple(:verum)) { DpllSolver::Formulas::Verum }
      rule(:falsum => simple(:falsum)) { DpllSolver::Formulas::Falsum }
      rule(:var => simple(:var)) { DpllSolver::Formulas::Variable.new(var) }
      rule(:not => { root_formula: subtree(:root_formula) }) { DpllSolver::Formulas::Not.new(root_formula) }
      rule(:or => {left: subtree(:left), right: subtree(:right) }) { DpllSolver::Formulas::Or.new(left, right) }
      rule(:and => {left: subtree(:left), right: subtree(:right) }) { DpllSolver::Formulas::And.new(left, right) }
    end

    class Parser

      def self.formula_to_clause(formula)
        f_cnf = formula.simplify.cnf
        if f_cnf.verum?
          return Set.new
        elsif f_cnf.falsum?
          return Set.new([DpllSolver::Formulas::Clause.new])
        elsif f_cnf.variable?
          literal = DpllSolver::Formulas::Literal.new(f_cnf, true)
          return Set.new([DpllSolver::Formulas::Clause.new(literal)])
        elsif f_cnf.not?
          literal = DpllSolver::Formulas::Literal.new(f_cnf.f, false)
          return Set.new([DpllSolver::Formulas::Clause.new(literal)])
        elsif f_cnf.and?
          c1 = self.formula_to_clause(f_cnf.f1)
          c2 = self.formula_to_clause(f_cnf.f2)
          return c1 + c2
        elsif f_cnf.or?
          c1 = self.formula_to_clause(f_cnf.f1)
          c2 = self.formula_to_clause(f_cnf.f2)
          return Set.new([c1.first.union(c2.first)])
        else
          raise TypeError, "Formula has to be one of these classes: Verum, Falsum, Variable, And, Or, Not"
        end
      end

    end
  end
end
