module QualityControl
  # Rubocop plugin
  module Rubocop
    class << self
      attr_writer :directories

      # Directories attr_reader with default value
      #
      # @return [Array] The array of directories to run rubocop.
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
