module DpllSolver
  module Formulas
    class Variable
      include AtomicFormula
      attr_accessor :name
      alias :to_s :name
      def initialize(name)
        @name = name
      end

      def ==(other)
        other.class == self.class && other.to_s == self.to_s
      end
      alias :eql? :==

      def variable?
        true
      end
      def verum?
        false
      end
      alias falsum? verum?

    end
  end
end
