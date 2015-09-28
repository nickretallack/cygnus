environment ENV['RAILS_ENV'] || 'development'
daemonize

port 3000

pidfile    "bin/puma_app1.pid"