require_relative 'ambient_request'

class BMELogger
 attr_accessor :level
 attr_accessor :formatter

 def level
  @level ||= Logger::INFO
 end

  def logger
    @log ||= Logger.new('log/app.log', 'daily')
    @log.level = level
    @log
  end

  def logster_logger
    @logster_logger = $log
  end

  def error(message)
    logster_logger.error message unless logster_logger.nil?
    logger.error message
  end

  def debug(message)
    logster_logger.debug message unless logster_logger.nil?
    logger.debug message
  end

  def info(message)
    logster_logger.info message  unless logster_logger.nil?
    logger.info message
  end

  def warn(message)
    logster_logger.warn message unless logster_logger.nil?
    logger.warn message
  end

  def fatal(message)
    logster_logger.fatal message unless logster_logger.nil?
    logger.fatal message
  end
end


module TheLogger
  def self.log
    @log ||= BMELogger.new()
  end
end
