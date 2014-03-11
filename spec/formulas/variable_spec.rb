require 'spec_helper'

describe DpllSolver::Formulas::Variable do
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  it 'should have "x1" as string and name' do
    expect(var1.to_s).to eql "x1"
    expect(var1.name).to eql "x1"
  end

  it 'should test syntactic eqivalenz' do
    expect(var1 == var2).to eql false
    expect(var1 == DpllSolver::Formulas::Variable.new("x1")).to eql true
  end

  it 'should be a literal' do
    expect(var1.literal?).to eql true
  end

  it 'should be a atomic formula' do
    expect(var1.atomic_formula?).to eql true
  end

  it 'should be a min term' do
    expect(var1.min_term?).to eql true
  end

  it 'should be a nnf' do
    expect(var1.nnf?).to eql true
  end

  it 'should be a cnf' do
    expect(var1.cnf?).to eql true
  end

  it 'should be a dnf' do
    expect(var1.dnf?).to eql true
  end

  it 'should simplify variable' do
    expect(var1.simplify).to eql var1
  end
end

