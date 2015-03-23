module BME
  class IFindHelpersForRequest
    def initialize requests_helper
      @requests_helper = requests_helper
    end

    def start request
      Thread.new{find_helpers_for_request request}
    end

    def get_number_of_helpers_to_call iteration
      number_of_helpers_to_call = iteration / 2
      if number_of_helpers_to_call == 0
        number_of_helpers_to_call = 1
      end
      [number_of_helpers_to_call,10].min
    end

    def find_helpers_for_request request
      500.times do |iteration|
        TheLogger.log.info "thread finding helpers for request #{request} iteration: #{iteration}"
        request.reload
       if request.stopped || request.answered
         Thread.current.kill
       end
       number_of_helpers_to_call = get_number_of_helpers_to_call iteration
        @requests_helper.check_request request, number_of_helpers_to_call
        TheLogger.log.info "finished finding helpers"
        sleep 4 # seconds
      end
    end
  end
end
