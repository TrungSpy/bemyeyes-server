class EventHandlerBase
  include ActiveSupport::Rescuable
  rescue_from StandardError, with: :known_error

  def helper
    @helper ||= Helper.first(_id: @payload[:helper_id])
    @helper
  end

  def request
    @request ||= Request.first(_id: @payload[:request_id])
    @request
  end

  protected
  def known_error(error)
    TheLogger.log.error "event_handler error #{error.message} #{error.backtrace}"
  end
end
