module QualityControl
  module SCSS
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
  task :scss do
    verbose false
    sh "scss-lint #{QualityControl::SCSS.directories.join ' '}"
  end
end
