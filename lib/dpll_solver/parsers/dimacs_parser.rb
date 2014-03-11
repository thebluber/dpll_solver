module DpllSolver
  module Parsers
    class DimacsParser
      attr_accessor :file, :num_vars, :num_clauses, :clauseset
      def initialize(file_path)
        @file = file_path
        @clauseset = Set.new
        @num_clauses = 0
        @num_vars = 0
        parse
      end

      private
      def parse
        begin
          lines = open(@file).readlines
          lines.each do |line|
            line = line.gsub("\n", "").strip.split
            next if line[0] == "c"
            if line[0] == "p"
              @num_vars = line[2].to_i
              @num_clauses = line[3].to_i
            else
              line.pop
              if line.count > 0
                clause = DpllSolver::Formulas::Clause.new
                line.each do |num|
                  clause.add(create_literal(num))
                end
                @clauseset.add(clause)
              end
            end
          end
        rescue Exception => e
          puts e
          raise IOError, "Could not parse file #{@file}!"
        end
      end

      def create_literal(num)
        var = DpllSolver::Formulas::Variable.new("x#{num.to_i.abs}")
        DpllSolver::Formulas::Literal.new(var, num.to_i > 0)
      end
    end
  end
end
