web: bundle exec rails server Puma --port=$PORT
guard: guard --no-interactions
worker: bin/delayed_job run
clock: bundle exec clockwork lib/clock.rb
karma: bundle exec rake karma:start

