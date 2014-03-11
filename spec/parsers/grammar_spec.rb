require 'spec_helper'
require 'parslet/rig/rspec'

describe DpllSolver::Parsers::Grammar do
  let(:g){ DpllSolver::Parsers::Grammar.new }

  describe '#verum' do
    let(:verum){ g.verum }
    it 'should parse verum' do
      verum.should parse('T')
      verum.should parse('1')
    end
  end
  describe '#falsum' do
    let(:falsum){ g.falsum }
    it 'should parse falsum' do
      falsum.should parse('F')
      falsum.should parse('0')
    end
  end
  describe '#variable' do
    let(:var){ g.variable }
    it 'should parse variable' do
      var.should parse('x')
      var.should parse('x1')
      var.should parse('x12')
      var.should_not parse('xy')
    end
  end
  describe '#not' do
    let(:not_op){ g.not_operation }
    it 'should parse not_operation' do
      not_op.should parse('-x')
      not_op.should parse('-(x+y)')
      not_op.should parse('--x')
    end
  end
  describe '#or' do
    let(:or_op){ g.or_operation }
    it 'should parse or_operation' do
      or_op.should parse('(x + y)')
      or_op.should parse('(x | y)')
      or_op.should parse('(x OR y)')
    end
  end
  describe '#and' do
    let(:and_op){ g.and_operation }
    it 'should parse and_operation' do
      and_op.should parse('(x * y)')
      and_op.should parse('(x & y)')
      and_op.should parse('(x AND y)')
    end
  end
end
