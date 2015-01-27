module BME
  class Timer
    def self.time(&block)
      start_time = Time.now
      result = block.call
      end_time = Time.now
      @time_taken = end_time - start_time
      result
    end

    def self.elapsedTime
      return @time_taken
    end

  end

  class IFindHelpersForRequest
    def initialize requests_helper
      @request_helper = requests_helper
    end

    def start request
      Thread.new{find_helpers_for_request request}
    end

    def find_helpers_for_request request
      10.times do
        TheLogger.log.info "thread finding helpers for request #{request}"
        Timer.time {@requests_helper.check_request request, 1}
        TheLogger.log.info "finished finding helpers time elapsed: #{Timer.elapsedTime}"
        sleep 4 # seconds
      end
    end
  end
end
