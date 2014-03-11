module DpllSolver
  module Formulas
    class Falsum
      extend AtomicFormula
      def self.to_s
        '0'
      end

      def self.falsum?
        true
      end
      def self.verum?
        false
      end
    end
  end
end

