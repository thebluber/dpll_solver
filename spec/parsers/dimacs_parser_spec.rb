require 'spec_helper'

describe DpllSolver::Parsers::DimacsParser do
  let(:f1) { "resources/dimacs/yes/aim-50-1_6-yes1-1.cnf" }
  let(:f2) { "resources/dimacs/no/aim-50-1_6-no-1.cnf" }
  let(:f3) { "resources/dimacs/yes/aim-50-6_0-yes1-4.cnf" }

  it 'should parse files in DIMACS format' do
    parser = DpllSolver::Parsers::DimacsParser.new(f1)
    expect(parser.num_vars).to eql 50
    expect(parser.num_clauses).to eql 80
    expect(parser.clauseset.count).to eql 80
    parser = DpllSolver::Parsers::DimacsParser.new(f2)
    expect(parser.num_vars).to eql 50
    expect(parser.num_clauses).to eql 80
    expect(parser.clauseset.count).to eql 80
    parser = DpllSolver::Parsers::DimacsParser.new(f3)
    expect(parser.num_vars).to eql 50
    expect(parser.num_clauses).to eql 300
    expect(parser.clauseset.count).to eql 300
  end

end
