require 'spec_helper'

describe DpllSolver::Formulas::And do
  let(:falsum) { DpllSolver::Formulas::Falsum }
  let(:verum) { DpllSolver::Formulas::Verum }
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:f1) { DpllSolver::Formulas::Not.new(var1)}
  let(:f2) { DpllSolver::Formulas::And.new(var1, var2)}
  let(:f3) { DpllSolver::Formulas::And.new(f1, f2)}
  let(:f4) { DpllSolver::Formulas::And.new(f1, DpllSolver::Formulas::Not.new(f2))}
  it 'should convert to string' do
    expect(f2.to_s).to eql "(x1 AND x2)"
    expect(f3.to_s).to eql "((NOT x1) AND (x1 AND x2))"
    expect(f4.to_s).to eql "((NOT x1) AND (NOT (x1 AND x2)))"
  end

  it 'should test syntactic eqivalenz' do
    expect(f2 == f2).to eql true
    expect(f2 == DpllSolver::Formulas::And.new(var1, var2)).to eql true
    expect(f2 == f3).to eql false
  end

  it 'should not be a literal' do
    expect(f2.literal?).to eql false
    expect(f3.literal?).to eql false
    expect(f4.literal?).to eql false
  end

  it 'should not be a atomic formula' do
    expect(f2.atomic_formula?).to eql false
    expect(f3.atomic_formula?).to eql false
    expect(f4.atomic_formula?).to eql false
  end

  it 'should not be a clause' do
    expect(f2.clause?).to eql false
    expect(f3.clause?).to eql false
    expect(f4.clause?).to eql false
  end

  it 'should be a min term if both formulas are min term' do
    expect(f2.min_term?).to eql true
    expect(f3.min_term?).to eql true
    expect(f4.min_term?).to eql false
  end

  it 'should be a nnf, cnf, dnf if both formulas are in nnf, cnf or dnf' do
    expect(f2.nnf?).to eql true
    expect(f2.cnf?).to eql true
    expect(f2.dnf?).to eql true
    expect(f3.nnf?).to eql true
    expect(f3.cnf?).to eql true
    expect(f3.dnf?).to eql true
    expect(f4.nnf?).to eql false
    expect(f4.cnf?).to eql false
    expect(f4.dnf?).to eql false
  end

  it 'should simply and' do
    and_falsum1= DpllSolver::Formulas::And.new(var1, falsum)
    and_verum1 = DpllSolver::Formulas::And.new(var1, verum)
    and_falsum2 = DpllSolver::Formulas::And.new(falsum, var2)
    and_verum2 = DpllSolver::Formulas::And.new(verum, var2)
    not_f1 = DpllSolver::Formulas::Not.new(f1)
    and_not = DpllSolver::Formulas::And.new(not_f1, var1)
    expect(and_falsum1.simplify).to eql falsum
    expect(and_falsum2.simplify).to eql falsum
    expect(and_verum1.simplify).to eql var1
    expect(and_verum2.simplify).to eql var2
    expect(and_not.simplify).to eql var1
  end

end

