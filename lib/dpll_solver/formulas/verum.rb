module DpllSolver
  module Formulas
    class Verum
      extend AtomicFormula
      def self.to_s
        '1'
      end

      def self.verum?
        true
      end
      def self.falsum?
        false
      end
    end
  end
end

