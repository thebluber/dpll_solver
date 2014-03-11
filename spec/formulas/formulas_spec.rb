require 'spec_helper'

describe DpllSolver::Formulas do
  let(:falsum) { DpllSolver::Formulas::Falsum }
  let(:verum) { DpllSolver::Formulas::Verum }
  let(:var1) { DpllSolver::Formulas::Variable.new("x1") }
  let(:var2) { DpllSolver::Formulas::Variable.new("x2") }

  it 'should convert a formula correctly to nnf' do
    expect(falsum.nnf).to eql falsum
    expect(verum.nnf).to eql verum
    expect(var1.nnf).to eql var1

    #more complex formulas
    f = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::And.new(var1, falsum))
    f_nnf = DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var1), DpllSolver::Formulas::Not.new(falsum))
    expect(f.nnf).to eql f_nnf

    f = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(var1, var2), DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(falsum, var2))))
    f_nnf = DpllSolver::Formulas::And.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var1), DpllSolver::Formulas::Not.new(var2)), DpllSolver::Formulas::Or.new(falsum, var2))
    expect(f.nnf).to eql f_nnf

    f = DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(var1, falsum), var2)), verum)
    f_nnf = DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var1), DpllSolver::Formulas::Not.new(falsum)), DpllSolver::Formulas::Not.new(var2)), verum)
    expect(f.nnf).to eql f_nnf
  end

  it 'should convert a formula correctly to cnf' do
    expect(falsum.cnf).to eql falsum
    expect(verum.cnf).to eql verum
    expect(var1.cnf).to eql var1

    #more complex formulas
    f = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::And.new(var1, falsum))
    f_cnf = DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var1), DpllSolver::Formulas::Not.new(falsum))
    expect(f.cnf).to eql f_cnf

    f = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(var1, var2), DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(falsum, var2))))
    f_cnf = DpllSolver::Formulas::And.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var1), DpllSolver::Formulas::Not.new(var2)), DpllSolver::Formulas::Or.new(falsum, var2))
    expect(f.cnf).to eql f_cnf

    f = DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::And.new(var1, falsum), var2)), verum)
    f_cnf = DpllSolver::Formulas::And.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var1), DpllSolver::Formulas::Not.new(falsum)), verum), DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Not.new(var2), verum))
    expect(f.cnf).to eql f_cnf
  end

end
