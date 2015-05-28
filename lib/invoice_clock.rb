require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

class InvoiceClock
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
      manager.log 'Invoice tick.'

      Account.find_each do |account|
        InvoiceJob.perform_later(account)
      end

      sleep @frequency
    end
  end
end

