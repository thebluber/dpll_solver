require 'spec_helper'

describe DpllSolver::Formulas::Verum do
  let(:verum) { DpllSolver::Formulas::Verum }
  it 'should be "1" as string' do
    expect(verum.to_s).to eql "1"
  end

  it 'should test syntactic eqivalenz' do
    expect(verum == DpllSolver::Formulas::Verum).to eql true
    expect(verum == DpllSolver::Formulas).to eql false
  end

  it 'should be a literal' do
    expect(verum.literal?).to eql true
  end

  it 'should be a atomic formula' do
    expect(verum.atomic_formula?).to eql true
  end

  it 'should be a min term' do
    expect(verum.min_term?).to eql true
  end

  it 'should be a nnf' do
    expect(verum.nnf?).to eql true
  end

  it 'should be a cnf' do
    expect(verum.cnf?).to eql true
  end

  it 'should be a dnf' do
    expect(verum.dnf?).to eql true
  end

  it 'should simplify verum' do
    expect(verum.simplify).to eql verum
  end
end

