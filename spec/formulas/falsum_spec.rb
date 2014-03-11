require 'spec_helper'

describe DpllSolver::Formulas::Falsum do
  let(:falsum) { DpllSolver::Formulas::Falsum }
  it 'should be "0" as string' do
    expect(falsum.to_s).to eql "0"
  end

  it 'should test syntactic eqivalenz' do
    expect(falsum == DpllSolver::Formulas::Falsum).to eql true
    expect(falsum == DpllSolver::Formulas).to eql false
  end

  it 'should be a literal' do
    expect(falsum.literal?).to eql true
  end

  it 'should be a atomic formula' do
    expect(falsum.atomic_formula?).to eql true
  end

  it 'should be a min term' do
    expect(falsum.min_term?).to eql true
  end

  it 'should be a nnf' do
    expect(falsum.nnf?).to eql true
  end

  it 'should be a cnf' do
    expect(falsum.cnf?).to eql true
  end

  it 'should be a dnf' do
    expect(falsum.dnf?).to eql true
  end

  it 'should simplify falsum' do
    expect(falsum.simplify).to eql falsum
  end
end

