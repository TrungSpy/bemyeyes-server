require_relative './init'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

describe "Device" do
  before do
    IntegrationSpecHelper.InitializeMongo()
  end
  before(:each) do
    Device.destroy_all
  end

  it "reports device as blocked if previous device with blocked user exists " do 
    dt = "device_token"
    blind = build(:blind)
    blind.blocked = true

    device = Device.new
    device.device_token = dt

    blind.devices << device
    blind.save

    expect(Device.is_blocked_user dt).to be(true)
  end

  it "reports device as not blocked if no previous device with blocked user exists " do 
    dt = "device_token"
    blind = build(:blind)

    device = Device.new
    device.device_token = dt

    blind.devices << device
    blind.save

    expect(Device.is_blocked_user dt).to be(false)
  end

end

