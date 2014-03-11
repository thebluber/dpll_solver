# DpllSolver

This is a small SAT solving tool using [DPLL algorithm](http://en.wikipedia.org/wiki/DPLL_algorithm). It can evaluate both a DIMACS file (max. 20 variables, 80 lines) and a boolean expression in string format i.e. '(x1 * (x3 + x4))' and determin wether the input is satisfiable.

## Installation

Add this line to your application's Gemfile:

    gem 'dpll_solver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dpll_solver

## Usage

#### Utilities
```ruby
require 'dpll_solver'

#to_cnf converts a boolean string to formula in conjunctive normal form
DpllSolver::Util.to_cnf('(x1 + -x6)').to_s # => "(x1 OR -x6)"

#to_clause converts a boolean expression to a set of clauses
class Set
  def to_s
    map(&:to_s)
  end
end
DpllSolver::Util.to_clause('(x1 + -x6)').to_s # => ["{x1, -x6}"]

#SAT? determins wether a boolean expression is satisfiable
DpllSolver::Util.SAT?('T') # => true
DpllSolver::Util.SAT?('1') # => true
DpllSolver::Util.SAT?('F') # => false
DpllSolver::Util.SAT?('0') # => false
DpllSolver::Util.SAT?('(x1 + -x6)') # => true

#dimacs_SAT? determins wether a cnf file in DIMACS format is satisfiable
DpllSolver::Util.dimacs_SAT?('resources/dimacs/yes/uf20-01.cnf') # => true
DpllSolver::Util.dimacs_SAT?('resources/dimacs/no/uf20-01.cnf') # => false

#tautology?
DpllSolver::Util.tautology?('1') # => true
DpllSolver::Util.tautology?('(x1 + -x6)') # => false

#contradiction?
DpllSolver::Util.contradiction?('0') # => true
DpllSolver::Util.contradiction?('(x1 + -x6)') # => false
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
