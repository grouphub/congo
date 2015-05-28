class Tick
  attr_accessor :clock

  def self.queue_name(name = nil)
    if name
      @queue_name = name
    else
      @queue_name
    end
  end

  def initialize(clock)
    @clock = clock
  end
end

# Require all ticks that are in the lib/ticks directory.
Dir.glob("#{Rails.root}/lib/ticks/**/*.rb").each do |file|
  require file
end

class Clock
  attr_accessor :log_file, :frequency, :queues, :logger

  TICKS = ObjectSpace.each_object(::Class)
    .select { |klass| klass < Tick }
    .inject({}) { |ticks, klass|
      ticks[klass.queue_name] = klass
      ticks
    }

  def initialize
    @log_file = STDOUT
    @frequency = 60
    @queues = %w[enrollment invoice].map(&:to_sym)

    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: TODO'

      opts.on('-l', '--log-file=FILE', 'Write log to FILE') do |file|
        @log_file = file
      end

      opts.on('-f', '--frequency=SECONDS', 'How often each job should run in SECONDS') do |frequency|
        @frequency = frequency.to_i
      end

      opts.on('-q', '--queues=QUEUES', 'Comma-separated list of QUEUES') do |queues|
        @queues = queues.split(',').map(&:strip).map(&:to_sym)
      end
    end

    parser.parse!

    @logger = Logger.new(log_file)
  end

  def start
    ticks = queues.map { |queue|
      TICKS[queue].new(self)
    }

    threads = ticks.map { |tick|
      Thread.new do
        loop do
          tick.tick
          sleep(frequency)
        end
      end
    }

    threads.each do |thread|
      thread.join
    end
  end
end

if __FILE__ == $0
  Clock.new.start
end

