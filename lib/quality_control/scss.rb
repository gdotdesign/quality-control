module QualityControl
  # SCSS Plugin
  module SCSS
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
  desc 'Run a SCSS syntax check'
  task :scss do
    verbose false
    sh "scss-lint #{QualityControl::SCSS.directories.join ' '}"
  end
end
