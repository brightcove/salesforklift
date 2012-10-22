require 'spec_helper.rb'
require 'net/http'

describe Salesforklift::Job do
  
  it "createa a bulk request to saleforce with real credential and real network" do
    login = Salesforklift::Login.new
    result = login.login_sforce(TEST_USER_NAME, TEST_USER_PW, TEST_LOGIN_URL)    
    result.class.should eq(Salesforklift::LoginResponse)

    job = Salesforklift::Job.new(result.server_instance,
                          result.session_id,
                          "Contact",
                          :insert)
    job.create
    job.sf_job_id.should_not be_nil

    batch = Salesforklift::Batch.new(result.server_instance, result.session_id, job.sf_job_id)
    batch.create_from_file("spec/data/contact.csv")

    job.close

    batch_response = batch.query_status
    # the result might be a success message with batch ID, or an error 
    # of "Batch not completed" since Salesforce bulk API works asynchronously.
    batch.query_result.length.should > 0
  end
end
