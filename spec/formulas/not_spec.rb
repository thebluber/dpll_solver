require 'spec_helper'

describe DpllSolver::Formulas::Not do
  let(:falsum) { DpllSolver::Formulas::Falsum }
  let(:verum) { DpllSolver::Formulas::Verum }
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:f1) { DpllSolver::Formulas::Not.new(var1)}
  let(:f2) { DpllSolver::Formulas::Not.new(f1)}
  let(:f3) { DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Falsum)}
  it 'should convert to string' do
    expect(f1.to_s).to eql "(NOT x1)"
    expect(f2.to_s).to eql "(NOT (NOT x1))"
    expect(f3.to_s).to eql "(NOT 0)"
  end

  it 'should test syntactic eqivalenz' do
    expect(f1 == f1).to eql true
    expect(f1 == DpllSolver::Formulas::Not.new(var1)).to eql true
    expect(f1 == f2).to eql false
  end

  it 'should be a literal if contains an atomic formula' do
    expect(f1.literal?).to eql true
    expect(f2.literal?).to eql false
    expect(f3.literal?).to eql true
  end

  it 'should not be a atomic formula' do
    expect(f1.atomic_formula?).to eql false
    expect(f3.atomic_formula?).to eql false
  end

  it 'should be a min term if contains an atomic formula' do
    expect(f1.min_term?).to eql true
    expect(f3.min_term?).to eql true
    expect(f2.min_term?).to eql false
  end

  it 'should be a nnf, cnf, dnf if contains an atomic formula' do
    expect(f1.nnf?).to eql true
    expect(f1.cnf?).to eql true
    expect(f1.dnf?).to eql true
    expect(f3.nnf?).to eql true
    expect(f3.cnf?).to eql true
    expect(f3.dnf?).to eql true
    expect(f2.nnf?).to eql false
    expect(f2.cnf?).to eql false
    expect(f2.dnf?).to eql false
  end

  it 'should simplify not' do
    not_falsum = DpllSolver::Formulas::Not.new(falsum)
    not_verum = DpllSolver::Formulas::Not.new(verum)
    expect(not_falsum.simplify).to eql verum
    expect(not_verum.simplify).to eql falsum
    expect(f2.simplify).to eql var1
    not_f2 = DpllSolver::Formulas::Not.new(f2)
    expect(not_f2.simplify).to eql f1
    not_not_f2 = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Not.new(f2))
    expect(not_not_f2.simplify).to eql var1
  end

  it 'should apply DeMorgan' do
    not_var1 = DpllSolver::Formulas::Not.new(var1)
    not_var2 = DpllSolver::Formulas::Not.new(var2)
    and_f = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::And.new(var1, var2))
    and_f_after = DpllSolver::Formulas::Or.new(not_var1, not_var2)
    or_f = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(var1, var2))
    or_f_after = DpllSolver::Formulas::And.new(not_var1, not_var2)
    expect(and_f.apply_DeMorgan).to eql and_f_after
    expect(or_f.apply_DeMorgan).to eql or_f_after
    expect{ f1.apply_DeMorgan }.to raise_error(ArgumentError)
    expect{ f2.apply_DeMorgan }.to raise_error(ArgumentError)
  end
end

