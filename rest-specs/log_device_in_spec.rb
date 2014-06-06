require 'rest_client'
require 'shoulda'
require 'yaml'
require 'aescrypt'
require 'bcrypt'
require 'base64'

require_relative '../app'
require_relative '../models/token'
require_relative '../models/device'
require_relative '../models/user'
require_relative './rest_shared_context'
require_relative '../spec/integration_spec_helper'

describe "log device in" do
    include_context "rest-context"
    it "can create a device without user token" do  
        register_device
    end

    it "cannot log user in without device token" do 
        #create user
        create_user
        #log user in
        loginUser_url = "#{@servername_with_credentials}/users/login"
        expect{RestClient.post loginUser_url, 
        {'email' => @email, 'password'=> @password}.to_json}
        .to raise_error(RestClient::BadRequest)
    end

    it "can log a user in with a device token, device is logged in" do
        create_user
        token = register_device
        #log user in
        loginUser_url = "#{@servername_with_credentials}/users/login"
        RestClient.post loginUser_url, 
        {'email' => @email, 'password'=> @password, 'device_token' => 'device_token'}.to_json
 
        device = Device.first(:device_token => token)
        device.is_logged_in.should be(true)
    end

    it "can log a user in with a device token, device belongs to user" do
        create_user
        token = register_device
        #log user in
        loginUser_url = "#{@servername_with_credentials}/users/login"
        RestClient.post loginUser_url, 
        {'email' => @email, 'password'=> @password, 'device_token' => 'device_token'}.to_json
 
        user = User.first(:email => @email)
        user.devices.select{|d| d.device_token == token}.length.should be(1)
    end

    it "can log user out with token, device is logged out" do
        create_user
        device_token = register_device
        #log user in
        loginUser_url = "#{@servername_with_credentials}/users/login"
        response = RestClient.post loginUser_url, 
        {'email' => @email, 'password'=> @password, 'device_token' => device_token}.to_json
        jsn = JSON.parse(response.to_s)
        token = jsn["token"]["token"]

        logoutUser_url  = "#{@servername_with_credentials}/users/logout"
        response = RestClient.put logoutUser_url, {'token'=> token}.to_json
 
        device = Device.first(:device_token => device_token)
        device.is_logged_in.should be(false)

    end

    it "can log user out with token and token is deleted" do
        #create user
        create_user
        #log user in
        loginUser_url = "#{@servername_with_credentials}/users/login"
        response = RestClient.post loginUser_url, 
        {'email' => @email, 'password'=> @password, 'device_token' => 'device_token'}.to_json
        jsn = JSON.parse(response.to_s)
        token = jsn["token"]["token"]

        #log user out
        logoutUser_url  = "#{@servername_with_credentials}/users/logout"
        response = RestClient.put logoutUser_url, {'token'=> token}.to_json

        Token.all(:token => token).count.should eq(0)
    end
end
