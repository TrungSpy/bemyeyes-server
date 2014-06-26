require_relative  './notification_handler'
require 'urbanairship'

module IphoneNotifier

  def initialize_urbanairship
    Urbanairship.application_key =  @ua_config['app_key']
    Urbanairship.application_secret = @ua_config['app_secret']
    Urbanairship.master_secret = @ua_config['master_secret']
    Urbanairship.request_timeout = 5 # default
    Urbanairship.logger = @logger.log
  end

  def send_notifications request, device_tokens
    initialize_urbanairship
    # Create notification
    user = request.blind
    notification_args_name = user.to_s
    notification = {
      :device_tokens => device_tokens,
      :aps => {
        :alert => {
          :"loc-key" => "PUSH_NOTIFICATION_ANSWER_REQUEST_MESSAGE",
          :"loc-args" => [ notification_args_name ],
          :"action-loc-key" => "PUSH_NOTIFICATION_ANSWER_REQUEST_ACTION",
          :short_id => request.short_id,
          },
          :sound => "call.aiff"
        }
      }
    # Send notification
    Urbanairship.push(notification)
     device_tokens.each do |token|
       TheLogger.log.info("sending request to token device " + token)
     end
     TheLogger.log.info "Push notification handled by: " + self.class.to_s
  end

  def register_device(device_token, options = {})
    initialize_urbanairship
     Urbanairship.register_device(device_token, options)
     TheLogger.log.info "Register device handled by: " + self.class.to_s
  end

  def init(ua_config, logger)
    @ua_config = ua_config
    @logger = logger
  end
end

class IphoneProductionNotifier < NotificationHandler
  include IphoneNotifier

  def initialize(ua_config, logger)
    init ua_config, logger
  end

  def include_device? device
    not device.development and device.system_version =~ /iPhone.*/
  end

end

class IphoneDevelopmentNotifier < NotificationHandler
  include IphoneNotifier

  def initialize(ua_config, logger)
    init ua_config, logger
  end

  def include_device? device
    device.development and device.system_version =~ /iPhone.*/
  end
end
