require 'logger'

module Salesforklift
  module Logging

    @@default_logger = Logger.new(STDOUT)
    @@default_logger.level = Logger::DEBUG
    
    def logger
      @logger ||= @@default_logger
    end

    def self.logger=(value)
      @@default_logger = value
    end
  end
end
