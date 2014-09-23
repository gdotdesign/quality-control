require 'pathname'
require 'opal'
require 'opal/rspec/rake_task'
require 'execjs'

Opal.append_path File.expand_path('../../../opal', __FILE__).untaint

module Opal
  module RSpec
    class RakeTask
      def exit(code)
        fail if code == 1
      end
    end
  end
end

module QualityControl
  module OpalRspec
    class << self
      attr_writer :files, :treshold

      def files
        @files ||= /.*\.rb/
      end

      def treshold
        @treshold ||= 0
      end
    end

    class PostProcessor < Sprockets::Processor
      def context
        return @context if @context
        code = 'var window = {};' +
          (%w(esprima escodegen istanbul).map { |file|
            path = File.expand_path("../../../vendor/#{file}", __FILE__).untaint
            File.read("./vendor/#{file}.js")
          }.join '') +
          """
          var Instrument = function(data,file){
            var instrumenter = new window.Instrumenter(),
            changed = instrumenter.instrumentSync(data,file);
            return '(function(){ ' + changed + '})();'
          }
          """
        @context = ExecJS.compile code
        @context
      end

      def instrument(data, file)
        context.call 'Instrument', data, file
      end

      def evaluate(_context, _)
        first    = Pathname.new file
        second   = Pathname.new Dir.pwd
        relative = first.relative_path_from(second).to_s

        if relative =~ QualityControl::OpalRspec.files
          instrument data, relative
        else
          data
        end
      end
    end
  end
end

Opal::RSpec::RakeTask.new("opal:rspec")
Opal::RSpec::RakeTask.new("opal:rspec:coverage:runner") do |server|
  server.sprockets.register_postprocessor('application/javascript', QualityControl::OpalRspec::PostProcessor)
end

desc 'Check opal specs coverage'
task "opal:rspec:coverage" do
  output = QualityControl.capture_stream :stdout do
    Rake::Task['opal:rspec:coverage:runner'].invoke
  end
  puts output.inspect
  coverage = output.match(/Coverage:\s(\d+)%/)[1].to_i
  fail if coverage < QualityControl::OpalRspec.treshold
end
