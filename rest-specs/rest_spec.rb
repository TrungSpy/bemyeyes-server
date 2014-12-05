require_relative './rest_shared_context'

describe "Rest api" do
  include_context "rest-context"
  describe "update user" do
    it "can update a user after creation" do
      id, auth_token = create_user
      url = "#{@servername_with_credentials}/users/" + id
      response = RestClient.put url, {'first_name' =>'my first_name',
                                      'last_name'=>'last_name', 'email'=> @email,
                                      'role'=> 'helper', 'password'=> @password }.to_json

      expect(response.code).to eq(200)
    end
  end

  describe "snooze" do
    it "can create user and then snooze" do
      id, auth_token = create_user

      url = "#{@servername_with_credentials}/users/"+id + "/snooze/1h"
      response = RestClient.put url, {}.to_json
      expect(response.code).to eq(200)

    end
  end
  describe "create user" do
    it "can create a user and get it" do
      id, auth_token= create_user

      getUser_url = "#{@servername_with_credentials}/users/" + id
      response = RestClient.get getUser_url, {:accept => :json}
      expect(response.code).to eq(200)

      jsn = JSON.parse response.body
      expect(jsn['first_name']).to eq('first_name')
    end

    it "can create a user" do
      url = "#{@servername_with_credentials}/users/"
      response = RestClient.post url, {'first_name' =>'first_name',
                                       'last_name'=>'last_name', 'email'=> @email,
                                       'role'=> 'helper', 'password'=> @password }.to_json
      expect(response.code).to eq(200)
    end

    it "can create user,log in and log out" do
      #create user
      id, auth_token = create_user
      token = log_user_in
      register_device auth_token
      
      #log user out
      logoutUser_url  = "#{@servername_with_credentials}/auth/logout"
      response = RestClient.put logoutUser_url, {'auth_token'=> auth_token}.to_json

      expect(response.code).to eq(200)
    end
  end
  describe 'time specific behaviour' do
    def change_awake_info params

      id, auth_token = create_user
      token = log_user_in
      register_device auth_token
      url = "#{@servername_with_credentials}/users/info/" + auth_token
      response = RestClient.put url, params
      expect(response.code).to eq(200)

      user = User.first(:_id => id)
      user
    end

    it "needs a valid token to change settings" do
      id, auth_token = create_user
      token = log_user_in
      register_device auth_token
     

      invalid_token = '123'
      url = "#{@servername_with_credentials}/users/info/"+ invalid_token
      expect{RestClient.put url, {'wake_up' =>'10:00', 'go_to_sleep' => '20:00'}.to_json}
      .to raise_error(RestClient::Unauthorized)
    end

    it "can update wake up and go to sleep" do
      user = change_awake_info({'wake_up' =>'10:00', 'go_to_sleep' => '20:00'
                                }.to_json)

      expect(user.wake_up).to eq('10:00')
      expect(user.go_to_sleep).to eq('20:00')
    end

    it "can update utc_offset" do
      user = change_awake_info( {'utc_offset' =>'-10'
                                 }.to_json)

      expect(user.utc_offset).to eq(-10)
    end

    it "does not update if wrong format for wake up and go to sleep" do

      user = change_awake_info(  {'wake_up' =>'6:00', 'go_to_sleep' => '8:00'
                                  }.to_json)
      #default values
      expect(user.wake_up).to eq('07:00')
      expect(user.go_to_sleep).to eq('22:00')
    end

    it "does not update if utc_offset is in the wrong format" do
      user = change_awake_info( {'utc_offset' =>'abc'
                                 }.to_json)
      #default values
      expect(user.utc_offset).to eq(2)
    end
  end
end
