require_relative './rest_shared_context'
require_relative '../spec/integration_spec_helper'

describe "User" do
  include_context "rest-context"

  it "create will accept integer for user_id" do
    create_user_with_user_id 42
  end

  it "create will accept string for user_id" do
    str = (Time.now.to_f*100000).to_s
    create_user_with_user_id str
  end

   it "update will accept string for user_id" do
     user_id = (Time.now.to_f*100000).to_s
     id, _auth_token = create_user_with_user_id user_id
     new_user_id = user_id + "new"

     update_user_with_user_id id, new_user_id

     expect(User.count(:user_id => new_user_id)).to eq(1)
  end

  it "update will accept integer for user_id" do
    user_id = 42
    id, _auth_token = create_user_with_user_id user_id
    new_user_id = user_id + 2
    update_user_with_user_id id, new_user_id

     expect(User.count(:user_id => new_user_id.to_s)).to eq(1)
  end

  def update_user_with_user_id(id, user_id)
    updateUser_url = "#{@servername_with_credentials}/users/#{id}"
    response = RestClient.put updateUser_url, {'first_name' =>'first_name',
                                               'last_name'=>'last_name', 'email'=> @email,
                                               'role'=> 'helper', 'password'=> @password, 'user_id' => user_id}.to_json

    expect(response.code).to eq(200)

    jsn = JSON.parse response.body
    id = jsn['id']
    auth_token = jsn['auth_token']
    return id, auth_token

  end

  def create_user_with_user_id(user_id)
    createUser_url = "#{@servername_with_credentials}/users/"
    response = RestClient.post createUser_url, {'first_name' =>'first_name',
                                                'last_name'=>'last_name', 'email'=> @email,
                                                'role'=> 'helper', 'password'=> @password, 'user_id' => user_id}.to_json

    expect(response.code).to eq(200)

    jsn = JSON.parse response.body
    id = jsn['id']
    auth_token = jsn['auth_token']
    return id, auth_token
  end

end

