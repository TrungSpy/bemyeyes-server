class SendResetNotifications
  def initialize(requests_helper)
    @requests_helper = requests_helper
  end

  def send _payload, _something
      SendResetNotificationsJob.new().async.perform(@requests_helper)
  end
end

class SendResetNotificationsJob
  include SuckerPunch::Job
  workers 4
  SuckerPunch.logger = TheLogger.log

  def perform  requests_helper
    _param_not_used = nil
    requests_helper.request_answered(_param_not_used)
  end
end
