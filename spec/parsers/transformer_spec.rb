require 'spec_helper'

describe DpllSolver::Parsers::Transformer do
  let(:g){ DpllSolver::Parsers::Grammar.new }
  let(:trans){ DpllSolver::Parsers::Transformer.new }

  it 'should transform literals' do
    verum = g.parse('T')
    falsum = g.parse('F')
    var = g.parse('x1')
    expect(trans.apply(verum)).to eql DpllSolver::Formulas::Verum
    expect(trans.apply(falsum)).to eql DpllSolver::Formulas::Falsum
    expect(trans.apply(var)).to eql DpllSolver::Formulas::Variable.new('x1')
  end

  it 'should transform functions' do
    not_op = g.parse('-z')
    or_op = g.parse('(x OR y)')
    and_op = g.parse('(x AND y)')
    expect(trans.apply(not_op)).to eql DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Variable.new('z'))
    expect(trans.apply(or_op)).to eql DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Variable.new('x'), DpllSolver::Formulas::Variable.new('y'))
    expect(trans.apply(and_op)).to eql DpllSolver::Formulas::And.new(DpllSolver::Formulas::Variable.new('x'), DpllSolver::Formulas::Variable.new('y'))
  end

  it 'should transform nested functions' do
    f = g.parse('-(a OR ((b OR -c) AND d))')
    parsed = DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Variable.new('a'), DpllSolver::Formulas::And.new(DpllSolver::Formulas::Or.new(DpllSolver::Formulas::Variable.new('b'), DpllSolver::Formulas::Not.new(DpllSolver::Formulas::Variable.new('c'))), DpllSolver::Formulas::Variable.new('d'))))
    expect(trans.apply(f)).to eql parsed
  end
end
