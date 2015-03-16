web: bin/start-pgbouncer-stunnel bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 1
piper: bundle exec rails runner bin/piper
