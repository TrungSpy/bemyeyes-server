require 'opentok'

class StartRecording < EventHandlerBase
  def start payload
    begin
      @payload = payload

      unless settings[:record_sessions]
        TheLogger.log.info "Starting session recording #{request.session_id}"
        return
      end

      opentok.archives.create(request.session_id, :name => "helper: " + helper.first_name)
    rescue Exception => e
      rescue_with_handler(e)
    end
  end
end

