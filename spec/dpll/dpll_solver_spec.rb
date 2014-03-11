require 'spec_helper'

describe DpllSolver::DPLL do
  let(:solver) { DpllSolver::DPLL.new(DpllSolver::Heuristics::MostFrequentLiteral) }
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:lit1) { DpllSolver::Formulas::Literal.new(var1, true)}
  let(:n_lit1) { DpllSolver::Formulas::Literal.new(var1, false)}
  let(:lit2) { DpllSolver::Formulas::Literal.new(var2, true)}
  let(:c1) { Set.new([DpllSolver::Formulas::Clause.new(lit1, lit2), DpllSolver::Formulas::Clause.new(lit1)])}
  let(:c2) { Set.new()}
  let(:c3) { Set.new([DpllSolver::Formulas::Clause.new(n_lit1, lit2), DpllSolver::Formulas::Clause.new(n_lit1)])}
  let(:c4) { Set.new([DpllSolver::Formulas::Clause.new(n_lit1), DpllSolver::Formulas::Clause.new(lit1)])}
  let(:c5) { Set.new([DpllSolver::Formulas::Clause.new, DpllSolver::Formulas::Clause.new(lit1)])}

  it 'should return the literal of a uni clause' do
    expect(solver.get_unit_clause_literal(c2)).to eql false
    expect(solver.get_unit_clause_literal(c1)).to eql lit1
    expect(solver.get_unit_clause_literal(c3)).to eql n_lit1
  end

  it 'should apply unit propagation on clauseset' do
    expect(solver.unit_propagation(c1, lit1)).to eql Set.new
    expect(solver.get_unit_clause_literal(solver.unit_propagation(c1, lit2))).to eql lit1
    expect(solver.unit_propagation(c3, lit1).count).to eql 2
    expect(solver.contains_empty_clause?(solver.unit_propagation(c3, lit1))).to eql true
  end

  it 'should apply dpll algorithm' do
    expect(solver.apply_dpll(c1)).to eql true
    expect(solver.apply_dpll(c2)).to eql true
    expect(solver.apply_dpll(c3)).to eql true
    expect(solver.apply_dpll(c4)).to eql false
    expect(solver.apply_dpll(c5)).to eql false
    l1 = DpllSolver::Formulas::Literal.new(DpllSolver::Formulas::Variable.new("x1"), true)
    l2 = DpllSolver::Formulas::Literal.new(DpllSolver::Formulas::Variable.new("x1"), true)
    l3 = DpllSolver::Formulas::Literal.new(DpllSolver::Formulas::Variable.new("x4"), true)
    c = Set.new([DpllSolver::Formulas::Clause.new(l1), DpllSolver::Formulas::Clause.new(l2, l3)])
    expect(solver.apply_dpll(c)).to eql true
  end

end

class Set
  def to_s
    map(&:to_s)
  end
end

describe DpllSolver::Util do
  let(:util) { DpllSolver::Util }
  let(:verum) { DpllSolver::Formulas::Verum }
  let(:falsum) { DpllSolver::Formulas::Falsum }
  let(:var) { DpllSolver::Formulas::Variable.new("x1") }
  let(:not_var) { DpllSolver::Formulas::Not.new(var) }
  let(:f1) { "resources/dimacs/yes/uf20-01.cnf" }
  let(:f2) { "resources/dimacs/yes/uf20-02.cnf" }
  let(:f3) { "resources/dimacs/yes/uf20-03.cnf" }
  let(:f4) { "resources/dimacs/yes/uf20-04.cnf" }
  let(:f5) { "resources/dimacs/no/uf20-01.cnf" }
  let(:f6) { "resources/dimacs/no/uf20-02.cnf" }

  it 'should transform a formula string into cnf' do
    expect(util.to_cnf('1')).to eql verum
    expect(util.to_cnf('0')).to eql falsum
    expect(util.to_cnf('x1')).to eql var
    expect(util.to_cnf('-x1')).to eql not_var
    expect(util.to_cnf('((a OR -b) AND (0 OR c))').to_s).to eql '((a OR -b) AND c)'
    expect(util.to_cnf('((a AND -b) OR (1 AND c))').to_s).to eql '((a OR c) AND (-b OR c))'
  end

  it 'should transform a formula string into clause' do
    expect(util.to_clause('1')).to eql Set.new
    expect(util.to_clause('0').to_s).to eql ["{}"]
    expect(util.to_clause('a').to_s).to eql ["{a}"]
    expect(util.to_clause('(a OR b)').to_s).to eql ["{a, b}"]
    expect(util.to_clause('(a AND b)').to_s).to eql ["{a}", "{b}"]
    expect(util.to_clause('(a AND (-b OR c))').to_s).to eql ["{a}", "{-b, c}"]
    expect(util.to_clause('((a AND -b) OR (1 AND c))').to_s).to eql ["{a, c}", "{-b, c}"]
  end

  it 'should check wether a formula is satisfiable' do
    expect(util.SAT?('1')).to eql true
    expect(util.SAT?('0')).to eql false
    expect(util.SAT?('x1')).to eql true
    expect(util.SAT?('(0 AND x1)')).to eql false
    expect(util.SAT?('-(0 AND x1)')).to eql true
    expect(util.SAT?('-(1 OR x1)')).to eql false
  end

  it 'should check wether a formula is tautology' do
    expect(util.tautology?('1')).to eql true
    expect(util.tautology?('x1')).to eql false
    expect(util.tautology?('-(0 AND x1)')).to eql true
    expect(util.tautology?('-(1 OR x1)')).to eql false
  end

  it 'should check wether a formula is contradiction' do
    expect(util.contradiction?('0')).to eql true
    expect(util.contradiction?('x1')).to eql false
    expect(util.contradiction?('(0 AND x1)')).to eql true
    expect(util.contradiction?('-(0 AND x1)')).to eql false
    expect(util.contradiction?('-(1 OR x1)')).to eql true
  end

  it 'should solve SAT problem of given file' do
    expect(util.dimacs_SAT?(f1)).to eql true
    expect(util.dimacs_SAT?(f2)).to eql true
    expect(util.dimacs_SAT?(f3)).to eql true
    expect(util.dimacs_SAT?(f4)).to eql true
    expect(util.dimacs_SAT?(f5)).to eql false
    expect(util.dimacs_SAT?(f6)).to eql false
  end
end
