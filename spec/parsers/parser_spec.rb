require 'spec_helper'

describe DpllSolver::Parsers::Parser do
  let(:falsum) { DpllSolver::Formulas::Falsum }
  let(:verum) { DpllSolver::Formulas::Verum }
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:f) { DpllSolver::Formulas::Not.new(var2) }
  let(:f1) { DpllSolver::Formulas::Not.new(DpllSolver::Formulas::And.new(var1, falsum)) }
  let(:f2) { DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(var1, var2), DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(falsum, var2)))) }
  let(:f3) { DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(var1, falsum), var2)), verum) }

  it 'should convert a formula to a set of clauses' do
    expect(DpllSolver::Parsers::Parser.formula_to_clause(falsum).map(&:to_s).join).to eql "{}"
    expect(DpllSolver::Parsers::Parser.formula_to_clause(verum).empty?).to eql true
    expect(DpllSolver::Parsers::Parser.formula_to_clause(var1).map(&:to_s).join).to eql "{x1}"
    expect(DpllSolver::Parsers::Parser.formula_to_clause(f).map(&:to_s).join).to eql "{-x2}"
    expect(DpllSolver::Parsers::Parser.formula_to_clause(f1).empty?).to eql true
    expect(DpllSolver::Parsers::Parser.formula_to_clause(f2).map(&:to_s).join).to match "{-x1, -x2}"
    expect(DpllSolver::Parsers::Parser.formula_to_clause(f2).map(&:to_s).join).to match "{x2}"
    expect(DpllSolver::Parsers::Parser.formula_to_clause(f3).empty?).to eql true
  end
end
