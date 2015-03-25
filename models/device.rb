class Device
  include MongoMapper::Document
  plugin MongoMapper::Plugins::ReadPreference

  belongs_to :user, class_name: "User"

  key :device_token, String, required: true, unique: true
  key :device_name, String
  key :model, String
  key :system_version, String
  key :app_version, String
  key :app_bundle_version, String
  key :locale, String
  key :development, Boolean, default: false
  key :inactive, Boolean, default: false

  timestamps!

  def self.is_blocked_user device_token
     devices = Device.where(device_token:device_token).all
    devices.find_all {|device| device.user.blocked}.length > 0
  end
end
