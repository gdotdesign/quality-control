require 'colorize'

# Record Rake task metadata for names
Rake::TaskManager.record_task_metadata = true

# Quality Control module
module QualityControl
  class << self
    attr_writer :tasks

    def tasks
      @tasks ||= []
    end

    def silence_stream(stream)
      old_stream = stream.dup
      null = RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null'
      stream.reopen null
      stream.sync = true
      yield
    ensure
      stream.reopen old_stream
    end

    def capture_stream(stream)
      stream = stream.to_s
      captured_stream = Tempfile.new(stream)
      stream_io = eval("$#{stream}")
      origin_stream = stream_io.dup
      stream_io.reopen(captured_stream)
      yield
      stream_io.rewind
      return captured_stream.read
    ensure
      captured_stream.unlink
      stream_io.reopen(origin_stream)
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
