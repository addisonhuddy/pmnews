if ENV["RAILS_ENV"] == "production"
  worker_processes 2 # amount of unicorn workers to spin up
else
  worker_processes 1
end

timeout 30

# this is required for New Relic to log data
preload_app true

# Disconnect in before_fork and reconnect in after_fork for your Database,
# Resque or other services. Without those handlers there will be regular database errors.
# http://blog.codeship.io/2012/05/06/Unicorn-on-Heroku.html
before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  sleep 1
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
end
