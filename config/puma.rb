environment ENV['RAILS_ENV'] || 'development'
daemonize

port 8080

pidfile    "bin/puma_app1.pid"
