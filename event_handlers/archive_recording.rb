require 'opentok'
require 'sucker_punch'
require_relative './event_handler_base'

class RecordingJob
  include SuckerPunch::Job

  def perform(opentok,request)
    helper = request.helper

    archive = opentok.archives.create(request.session_id, :name => "helper: " + helper.first_name)
    TheLogger.log.info "Starting session recording #{request.session_id} Archive id: #{ archive.id}"
    request.reload
    request.additional_info[:archive_id] = archive.id
    request.save!
  end

  def later(sec, opentok, request)
    after(sec) { perform(opentok, request) }
  end
end

class ArchiveRecording < EventHandlerBase
  def opentok
    opentok_config = settings['opentok']
    @opentok ||= OpenTok::OpenTok.new opentok_config['api_key'], opentok_config['api_secret']
    @opentok
  end

  def start payload
    begin
      @payload = payload

      return unless settings["record_sessions"]
      RecordingJob.new.async.later(5,opentok, request)

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

