# Run like: `bundle exec clockwork lib/enrollment_clock_runner.rb`

require "#{File.dirname(__FILE__)}/enrollment_clock"

EnrollmentClock.new(*ARGV).start

