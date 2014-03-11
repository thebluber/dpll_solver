class BinaryFormula
  attr_accessor :f1, :f2
  def initialize(f1, f2)
    @f1 = f1
    @f2 = f2
  end
  #syntactic equivalenz
  def ==(other)
    other.class == self.class && other.f1 == @f1 && other.f2 == @f2
  end
  alias eql? ==

  def literal?
    false
  end

  def atomic_formula?
    false
  end

  def nnf?
    @f1.nnf? && @f2.nnf?
  end

  def dnf?
    @f1.dnf? && @f2.dnf?
  end

  def nnf
    self.class.new(@f1.nnf, @f2.nnf)
  end
end

