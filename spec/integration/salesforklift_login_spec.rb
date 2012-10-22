require 'spec_helper'
require 'net/http'

describe Salesforklift::Login do

  it "logins to saleforce should pass with real credential and real network" do
    login = Salesforklift::Login.new
    result = login.login_sforce(TEST_USER_NAME, TEST_USER_PW, TEST_LOGIN_URL)
    result.class.should eq(Salesforklift::LoginResponse)
  end
end
