require 'spec_helper'

describe Salesforklift::Login do

  it "login to saleforce should return false if salesforce does not respond 200" do
    mock_http = double("mock_http")
    Net::HTTP.stub(:new).and_return(mock_http)
    # anything other than an HTTPOK object results in false
    mock_http.stub(:post).and_return(String.new)
    mock_http.stub(:use_ssl=)

    login = Salesforklift::Login.new
    result = login.login_sforce("jmao@greatcorp.com.salesforce", "Password!", "http://test.salesforce.com")
    result.class.should eq FalseClass
  end
end
