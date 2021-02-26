require 'lograge'
require 'securerandom'

module IdentityLogging
  class Railtie < Rails::Railtie
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new

    config.log_formatter = if Rails.env.development?
      IdentityLogging::DevelopmentLogFormatter
    else
      IdentityLogging::LogFormatter
    end

    config.lograge.custom_options = lambda do |event|
      event.payload[:timestamp] = Time.zone.now.iso8601
      event.payload[:uuid] = SecureRandom.uuid
      event.payload[:pid] = Process.pid
      event.payload[:user_agent] = event.payload[:request].user_agent
      event.payload[:ip] = event.payload[:request].remote_ip
      event.payload[:host] = event.payload[:request].host
      event.payload[:trace_id] = event.payload[:headers]['X-Amzn-Trace-Id']
      event.payload.except(:params, :headers, :request, :response)
    end
  end
end
