require 'yard'

module QualityControl
  module Yard
    class << self
      attr_writer :treshold

      def treshold
        @treshold ||= 0
      end

      def coverage
        klasses = YARD::Registry.load!.all(:class, :module, :root)

        documented = true
        ks     = klasses.map { |k| [k, doc_method_percent(k)] }
        sorted = ks.sort { |(_, percent), (_, percent2)| percent <=> percent2 }
        values = sorted.map do |(k, p)|
          puts "#{k} - #{p * 100}% undocumented"
          100 - p * 100
        end
        values.inject{|sum,x| sum + x } / values.count
      end

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
