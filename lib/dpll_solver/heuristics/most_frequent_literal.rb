module DpllSolver
  module Heuristics
    class MostFrequentLiteral
      def self.choose_literal(clauseset)
        raise ArgumentError, "clauseset must be a set of Clauses and not be empty!" if clauseset.empty?
        counter = Hash.new(0)
        most_frequent = nil
        clauseset.each do |clause|
          clause.literals.each do |literal|
            counter[literal] += 1
            if most_frequent
              most_frequent = literal if counter[literal] > counter[most_frequent]
            else
              most_frequent = literal
            end
          end
        end
        most_frequent
      end
    end
  end
end
