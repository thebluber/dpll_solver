module AtomicFormula
  #syntactic equivalenz
  def ==(other)
    other.class == self.class
  end

  def atomic_formula?
    true
  end

  alias literal? atomic_formula?
  alias min_term? atomic_formula?
  alias clause? atomic_formula?
  alias nnf? atomic_formula?
  alias cnf? atomic_formula?
  alias dnf? atomic_formula?

  def simplify
    self
  end

  alias nnf simplify
  alias cnf simplify
  alias dnf simplify

  def not?
    false
  end

  alias and? not?
  alias or? not?
  alias variable? not?
end

