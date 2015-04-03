require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

class EnrollmentClock
  attr_accessor :log_file, :frequency, :logger

  def initialize
    @log_file = STDOUT
    @frequency = 60

    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: TODO'

      opts.on( '-l', '--log-file FILE', 'Write log to FILE') do |file|
        @log_file = file
      end

      opts.on( '-f', '--frequency SECONDS', 'How often each job should run in SECONDS') do |frequency|
        @frequency = frequency.to_i
      end
    end

    parser.parse!

    @logger = Logger.new(log_file)
  end

  def start
    loop do
      logger.info 'Tick. Enrollment is currently disabled.'

      # manager.log 'Tick.'

      # Application.where('submitted_on IS NOT NULL AND completed_on IS NULL').find_each do |application|
      #   EnrollmentJob.perform_later(application.id)
      # end

      sleep @frequency
    end
  end
end

