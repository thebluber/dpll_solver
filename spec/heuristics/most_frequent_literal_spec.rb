require 'spec_helper'

describe DpllSolver::Heuristics::MostFrequentLiteral do
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:lit1) { DpllSolver::Formulas::Literal.new(var1, true)}
  let(:n_lit1) { DpllSolver::Formulas::Literal.new(var1, false)}
  let(:lit2) { DpllSolver::Formulas::Literal.new(var2, true)}
  let(:c1) { Set.new([DpllSolver::Formulas::Clause.new(lit1, lit2), DpllSolver::Formulas::Clause.new(lit1)])}
  let(:c2) { Set.new([DpllSolver::Formulas::Clause.new(lit1, lit2), DpllSolver::Formulas::Clause.new(n_lit1)])}
  let(:c3) { Set.new([DpllSolver::Formulas::Clause.new(n_lit1, lit2), DpllSolver::Formulas::Clause.new(n_lit1)])}
  
  it 'should return the most frequent literal in clause set' do
    expect{ DpllSolver::Heuristics::MostFrequentLiteral.choose_literal(Set.new)}.to raise_error
    expect(DpllSolver::Heuristics::MostFrequentLiteral.choose_literal(c1)).to eql lit1
    expect{ DpllSolver::Heuristics::MostFrequentLiteral.choose_literal(c2)}.not_to raise_error
    expect(DpllSolver::Heuristics::MostFrequentLiteral.choose_literal(c3)).to eql n_lit1
  end
end
