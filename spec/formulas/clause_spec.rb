require 'spec_helper'

describe DpllSolver::Formulas::Clause do
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:lit1) { DpllSolver::Formulas::Literal.new(var1, true) }
  let(:lit1_neg) { DpllSolver::Formulas::Literal.new(var1, false) }
  let(:lit2) { DpllSolver::Formulas::Literal.new(var2, true) }
  let(:c) { DpllSolver::Formulas::Clause.new()}
  let(:c1) { DpllSolver::Formulas::Clause.new(lit1)}
  let(:c2) { DpllSolver::Formulas::Clause.new(lit1, lit2)}

  it 'should test if clause is a unit clause' do
    expect(c1.unit?).to eql true
    expect(c2.unit?).to eql false
  end

  it 'should add and remove literal to clause' do
    expect(c1.add(lit2)).to eql c2
    c2.delete(lit2)
    expect(c2.unit?).to eql true
    expect(c2.delete(DpllSolver::Formulas::Literal.new(var1, true)).empty?).to eql true
  end

  it 'should detect if a clause is empty' do
    expect(c.empty?).to eql true
    expect(c1.empty?).to eql false
  end

  it 'should detect if a clause contains the given literal' do
    expect(c.include?(lit1)).to eql false
    expect(c1.include?(lit1)).to eql true
  end

  it 'should union a clause to an other' do
    c.union(c1)
    expect(c).to eql c1
  end

  it 'should get the unit literal' do
    c2.add(lit1_neg)
    expect(c2.get_unit_literal.nil?).to eql true
    expect(c1.get_unit_literal).to eql lit1
  end

  it 'should compare two clauses' do
    expect(c == c).to eql true
    expect(c1 == DpllSolver::Formulas::Clause.new(lit1)).to eql true
    expect(c1 == c2).to eql false
  end

  it 'should convert clause to string' do
    expect(c2.to_s).to eql "{x1, x2}"
  end
end
