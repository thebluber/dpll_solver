# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dpll_solver/version'

Gem::Specification.new do |spec|
  spec.name          = "dpll_solver"
  spec.version       = DpllSolver::VERSION
  spec.authors       = ["thebluber"]
  spec.email         = ["thebluber@gmail.com"]
  spec.description   = "This is a small SAT solving tool for either DIMACS file input (max. 20 variables, 80 lines) or boolean expressions in string format i.e. '(x1 * (x3 + x4))'."
  spec.summary       = "SAT solver using DPLL algorithm"
  spec.homepage      = "https://github.com/thebluber/dpll_solver"
  spec.license       = "MIT"
  
  resource_files = [
    'resources/dimacs/no/uf20-01.cnf',
    'resources/dimacs/no/uf20-02.cnf',
    'resources/dimacs/yes/uf20-01.cnf',
    'resources/dimacs/yes/uf20-02.cnf',
    'resources/dimacs/yes/uf20-03.cnf',
    'resources/dimacs/yes/uf20-04.cnf'
  ]
  spec.files         = `git ls-files`.split($/).reject{|file| resource_files.include? file}
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "binding_of_caller"
  spec.add_development_dependency "pry"
  spec.add_dependency "parslet"
end
