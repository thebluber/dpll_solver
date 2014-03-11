require 'spec_helper'

describe DpllSolver::Formulas::Literal do
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }
  let(:lit1) { DpllSolver::Formulas::Literal.new(var1, true) }
  let(:lit1_neg) { DpllSolver::Formulas::Literal.new(var1, false) }
  let(:lit2) { DpllSolver::Formulas::Literal.new(var2, true) }

  it 'should negate the literal' do
    expect(lit1.negate()).to eql lit1_neg
    expect(lit1_neg.negate()).to eql lit1
  end

  it 'should convert literal to string' do
    expect(lit2.to_s).to eql "x2"
    expect(lit1.to_s).to eql "x1"
    expect(lit1_neg.to_s).to eql "-x1"
  end

  it 'should compare two literals' do
    expect(lit1 == lit1).to eql true
    expect(lit1 == lit2).to eql false
    expect(lit1 == lit1_neg).to eql false
  end
end
