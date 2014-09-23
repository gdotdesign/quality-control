module QualityControl
  module Rubocop
    class << self
      attr_writer :directories

      def directories
        @directories ||= []
      end
    end
  end
end

namespace :syntax do
  desc 'Run a Ruby syntax check'
  task :ruby do
    verbose false
    sh "rubocop #{QualityControl::Rubocop.directories.join ' '}"
  end
end
