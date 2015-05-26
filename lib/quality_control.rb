require 'rake'
require 'colorize'

# Record Rake task metadata for names
Rake::TaskManager.record_task_metadata = true

# Quality Control module
module QualityControl
  class << self
    attr_accessor :after_task_callback
    attr_writer :tasks

    # Tasks attr_reader for default value
    #
    # @return [Array] The defined tasks or an empty array.
    def tasks
      @tasks ||= []
    end

    # Sliences the given stream.
    #
    # @param stream [Stream] The stream
    def silence_stream(stream)
      old_stream = stream.dup
      null = RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null'
      stream.reopen null
      stream.sync = true
      yield
    ensure
      stream.reopen old_stream
    end

    # Captures the given stream into a string
    #
    # @param stream [Stream] The stream
    #
    # @return [String] The output
    def capture_stream(stream)
      captured_stream = Tempfile.new SecureRandom.uuid
      origin_stream = stream.dup
      stream.reopen(captured_stream)
      yield
      stream.rewind
      return captured_stream.read
    ensure
      captured_stream.unlink
      stream.reopen(origin_stream)
    end
  end
end

desc 'Run continous integation tasks'
task :ci do
  fail = false
  QualityControl.tasks.each do |key|
    name = Rake::Task[key].full_comment
    begin
      QualityControl.silence_stream STDOUT do
        QualityControl.silence_stream STDERR do
          Rake::Task[key].invoke
        end
      end
      puts '✔'.green + " - #{name}"
    rescue
      puts '✘'.red + " - #{name}"
      fail = true
    end
  end
  exit fail ? 1 : 0
end
