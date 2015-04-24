require 'opentok'
require_relative './event_handler_base'


class ArchiveRecording < EventHandlerBase
  def start payload
    begin
      @payload = payload

      unless settings[:record_sessions]
        TheLogger.log.info "Starting session recording #{request.session_id}"
        return
      end

      archive = opentok.archives.create(request.session_id, :name => "helper: " + helper.first_name)
      request.additional_info[:archive_id] = archive.id
      request.save!
    rescue Exception => e
      rescue_with_handler(e)
    end
  end

  def stop payload
    begin
      @payload = payload

      unless settings[:record_sessions]
        TheLogger.log.info "Stopping session recording #{request.session_id}"
        return
      end

      opentok.archives.stop_by_id request.additional_info[:archive_id]
    rescue Exception => e
      rescue_with_handler(e)
    end
  end
end

