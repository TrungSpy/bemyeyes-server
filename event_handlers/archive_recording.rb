require 'opentok'
require_relative './event_handler_base'


class ArchiveRecording < EventHandlerBase
  def opentok
    opentok_config = settings['opentok']
    @opentok ||= OpenTok::OpenTok.new opentok_config['api_key'], opentok_config['api_secret']
    @opentok
  end

  def start payload
    begin
      @payload = payload

      unless settings["record_sessions"]
        return
      end

      archive = opentok.archives.create(request.session_id, :name => "helper: " + helper.first_name)
      TheLogger.log.info "Starting session recording #{request.session_id} Archive id: #{ archive.id}"
      request.reload
      request.additional_info[:archive_id] = archive.id
      request.save!
    rescue Exception => e
      rescue_with_handler(e)
    end
  end

  def stop payload
    begin
      @payload = payload

      return unless settings["record_sessions"]

      if request.additional_info[:archive_id].nil?
        TheLogger.log.error "Can't stop archive no archive id for session  #{request.session_id}"
        return
      end
      TheLogger.log.info "Stopping session recording #{request.session_id}"

      opentok.archives.stop_by_id request.additional_info[:archive_id]
    rescue Exception => e
      rescue_with_handler(e)
    end
  end
end

