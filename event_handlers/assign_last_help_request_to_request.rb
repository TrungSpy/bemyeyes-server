require_relative './event_handler_base'

class AssignLastHelpRequestToRequest < EventHandlerBase
  def helper_notified(payload)
    @payload = payload
    request.reload
    request.last_help_request = Time.now
    request.iteration = request.iteration + 1
    request.save!
  end
end
