require 'logger'

module Salesforklift
  module Logging

    @@defalut_logger = Logger.new(STDOUT)
    @@defalut_logger.level = Logger::INFO
    
    def logger
      @logger ||= @@defalut_logger
    end

    def self.logger=(value)
      @@defalut_logger = value
    end
  end
end
