class MarkHelperNotified
  def helper_notified(payload)
    request = payload[:request]
    helper = payload[:helper]
    request.reload
    helper.reload
    HelperRequest.create! request: request, helper: helper
  end
end
