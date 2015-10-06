require_relative './init'
require 'timecop'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
describe "Helper" do
  before do
    IntegrationSpecHelper.InitializeMongo()
  end
  before(:each) do
    User.destroy_all
    Device.destroy_all
    Request.destroy_all
  end

  describe "available" do

    it "finds someone whose native language is the same as mine" do
        request = build(:request)

        helper_non_en = build(:helper)
        helper_non_en.languages = ['ab', 'en']
        helper_non_en.first_name = "non-english"
        helper_non_en.create_or_renew_token
        helper_non_en.save!

        helper_en = build(:helper)
        helper_en.languages = ['en', 'de']
        helper_en.first_name = "english"
        helper_en.create_or_renew_token
        helper_en.save!

        request.blind.languages = ['en']
        request.blind.save!

      Timecop.freeze(Time.gm(2014,"jul",9,11,30) ) do
        expect(helper_en.available(request).count).to eq(1)
      end
    end

    it "finds someone whose second language is my native language only if no native speakers avaliable" do
      request = build(:request)

      helper_non_en = build(:helper)
      helper_non_en.languages = ['ab', 'de']
      helper_non_en.first_name = "non-english"
      helper_non_en.create_or_renew_token
      helper_non_en.save!

      helper_en = build(:helper)
      helper_en.languages = ['de', 'en']
      helper_en.first_name = "english"
      helper_en.create_or_renew_token
      helper_en.save!

      request.blind.languages = ['en']
      request.blind.save!

      Timecop.freeze(Time.gm(2014,"jul",9,11,30) ) do
        expect(helper_en.available(request).count).to eq(1)
      end
    end

    it "can get available helpers with language" do
      Timecop.freeze(Time.gm(2014,"jul",9,11,30) ) do
        request = build(:request)

        helper = request.helper
        helper.languages = ['ab', 'en']
        helper.first_name = "non-english"
        helper.create_or_renew_token
        helper.save!

        blind =request.blind
        blind.languages = ['en', 'da']
        blind.save!

        expect(helper.available(request).count).to eq(1)
      end
    end

    it "finds no available helpers when noone speaks blind persons languages" do
      request = build(:request)

      helper = request.helper
      helper.languages = ['ab', 'aa']
      helper.first_name = "non-english"
      helper.save!

      blind =request.blind
      blind.languages = ['en', 'da']
      blind.save!


      expect(helper.available(request).count).to eq(0)
    end
  end

  describe "languages" do
    it "can create a Helper with two languages" do
      helper = build(:helper)
      helper.languages = ['ab', 'aa']
      helper.save!
    end
  end
end
