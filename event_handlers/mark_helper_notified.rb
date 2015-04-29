class MarkHelperNotified < EventHandlerBase
  def helper_notified(payload)
    @payload = payload
    HelperRequest.create! request: request, helper: helper
  end
end
