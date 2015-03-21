require 'pathname'
require 'opal'
require 'opal/rspec/rake_task'
require 'execjs'

Opal.append_path File.expand_path('../../../opal', __FILE__).untaint

# Opal
module Opal
  # RSpec
  module RSpec
    # Rake Task
    class RakeTask
      # Exists the specs with code.
      #
      # @param code [Integer] The exit code
      def exit(code)
        fail if code == 1
      end
    end
  end
end

module QualityControl
  # Opal RSpec plugin
  module OpalRspec
    class << self
      attr_writer :files, :threshold

      # Files attr_reader with default value
      #
      # @return [RegExp] The regexp to match
      def files
        @files ||= /.*\.rb/
      end

      # The threshold for faliure.
      #
      # @return [Integer] The threshold
      def threshold
        @threshold ||= 0
      end
    end
  end
end

Opal::RSpec::RakeTask.new('opal:rspec') do
  Opal::Processor.dynamic_require_severity = :ignore
end

Opal::RSpec::RakeTask.new('opal:rspec:coverage:runner') do |server|
  module Opal
    module BuilderProcessors
      # Instrumenter Processor
      class RubyProcessor < Opal::BuilderProcessors::Processor
        # Returns the context of the processor
        #
        # @return [Object] The context
        def context
          return @context if @context
          code = <<-EOF
            var window = {}; #{vendor}
            var Instrument = function(data,file){
              var instrumenter = new window.Instrumenter(),
              changed = instrumenter.instrumentSync(data,file);
              return '(function(){ ' + changed + '})();'
            }
          EOF
          @context = ExecJS.compile code
        end

        # Instruments a file
        # @param data [String] The data
        # @param file [String] The file
        def instrument(data, file)
          context.call 'Instrument', data, file
        end

        # Runs on files that needed to be prcessed
        def source
          file_path = PathReader.new.expand(filename)
          relative = if file_path
                       first    = Pathname.new file_path.to_s
                       second   = Pathname.new Dir.pwd
                       first.relative_path_from(second).to_s
                     else
                       ''
                     end

          if relative =~ QualityControl::OpalRspec.files
            instrument compiled.result, filename
          else
            compiled.result
          end
        end

        private

        # Returns the files that are needed for
        # instrumenting js files.
        #
        # @return [String] The body of the files
        def vendor
          return @vendor if @vendor
          @vendor = %w(esprima escodegen istanbul).map do |file|
            File.read File.expand_path("../../../vendor/#{file}.js", __FILE__).untaint
          end.join ''
        end
      end
    end
  end
  Opal::Processor.dynamic_require_severity = :ignore
  server.debug = true
end

desc 'Check opal specs coverage'
task 'opal:rspec:coverage' do
  output = QualityControl.capture_stream STDOUT do
    Rake::Task['opal:rspec:coverage:runner'].invoke
  end
  coverage = output.match(/Coverage:\s(\d+)%/)[1].to_i
  fail if coverage < QualityControl::OpalRspec.threshold
end
