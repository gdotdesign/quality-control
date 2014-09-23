require 'yard'

module QualityControl
  # Yard plugin
  module Yard
    class << self
      attr_writer :treshold

      # The threshold for faliure.
      #
      # @return [Integer] The threshold
      def treshold
        @treshold ||= 0
      end

      # Calculates the coverage
      #
      # @return [Float] The coverage in percentage
      def coverage
        klasses = YARD::Registry.load!.all(:class, :module, :root)

        ks = klasses.map { |k| [k, doc_method_percent(k)] }
        sorted = ks.sort { |(_, percent), (_, percent2)| percent <=> percent2 }
        values = sorted.map do |(k, p)|
          puts "#{k} - #{p * 100}% undocumented"
          100 - p * 100
        end
        values.reduce(:+) / values.count
      end

      private

      # Calculates documentation percentage for a class.
      #
      # @param klass [Class] The class
      #
      # @return [Float] The documentation percentage
      def doc_method_percent(klass)
        total  = klass.meths.size.to_f
        undocd = klass.meths.select { |m| m.docstring.empty? }.size.to_f

        undocd.zero? ? 0.0 : (undocd / total)
      end
    end
  end
end

namespace :documentation do
  desc 'Generate documentation'
  YARD::Rake::YardocTask.new :generate

  desc 'Check documentation coverage'
  task :coverage do
    Rake::Task['documentation:generate'].invoke
    fail if QualityControl::Yard.coverage < QualityControl::Yard.treshold
  end
end
