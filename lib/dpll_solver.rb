# Require all of the Ruby files in the given directory.
# #
# # path - The String relative path from here to the directory.
# #
# # Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end
require 'parslet'
require 'set'
require 'dpll_solver/version'
require 'dpll_solver/atomic_formula'
require_all 'dpll_solver/formulas'
require_all 'dpll_solver/parsers'
require_all 'dpll_solver/heuristics'

module DpllSolver
  class Util
    @@grammar = DpllSolver::Parsers::Grammar.new
    @@transformer = DpllSolver::Parsers::Transformer.new
    def self.to_cnf(str)
      formula = @@grammar.parse(str)
      @@transformer.apply(formula).simplify().cnf()
    end

    def self.to_clause(str)
      formula = @@grammar.parse(str)
      DpllSolver::Parsers::Parser.formula_to_clause(@@transformer.apply(formula))
    end

    def self.dimacs_to_clause(file)
      parser = DpllSolver::Parsers::DimacsParser.new(file)
      parser.clauseset
    end

    def self.dimacs_SAT?(file)
      solver = DPLL.new(DpllSolver::Heuristics::MostFrequentLiteral)
      solver.apply_dpll(self.dimacs_to_clause(file))
    end

    def self.SAT?(str)
      solver = DPLL.new(DpllSolver::Heuristics::MostFrequentLiteral)
      solver.apply_dpll(self.to_clause(str))
    end

    def self.contradiction?(str)
      !self.SAT?(str)
    end

    def self.tautology?(str)
      formula = @@grammar.parse(str)
      #negate formula
      clause = DpllSolver::Parsers::Parser.formula_to_clause(DpllSolver::Formulas::Not.new(@@transformer.apply(formula)))
      solver = DPLL.new(DpllSolver::Heuristics::MostFrequentLiteral)
      !solver.apply_dpll(clause)
    end
  end

  class DPLL
    attr_accessor :heuristics
    def initialize(heuristics)
      @heuristics = heuristics
    end

    def apply_dpll(clauseset)
      literal = get_unit_clause_literal(clauseset)
      while literal do
        clauseset = unit_propagation(clauseset, literal)
        literal = get_unit_clause_literal(clauseset)
      end
      if clauseset.empty?
        return true
      elsif contains_empty_clause?(clauseset)
        return false
      end
      literal = @heuristics.choose_literal(clauseset)
      return apply_dpll(union_unit_clause(clauseset, literal)) || apply_dpll(union_unit_clause(clauseset, literal.negate()))
    end

    def contains_empty_clause?(clauseset)
      clauseset.each do |clause|
        return true if clause.empty?
      end
      return false
    end

    def get_unit_clause_literal(clauseset)
      clauseset.each do |clause|
        if clause.unit?
          return clause.literals.first
        end
      end
      return false
    end

    def unit_propagation(clauseset, literal)
      result = Set.new
      clauseset.each do |clause|
        if clause.include?(literal.negate())
          result.add(clause.delete(literal.negate()))
        elsif !clause.include?(literal)
          result.add(clause)
        end
      end
      result
    end

    def union_unit_clause(clauseset, literal)
      clauseset.dup.add(DpllSolver::Formulas::Clause.new(literal))
    end
  end
end
