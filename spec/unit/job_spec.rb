require "spec_helper"

describe Salesforklift::Job do
  it "generates job request" do
    expected = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<jobInfo xmlns="http://www.force.com/2009/06/asyncapi/dataload">
  <operation>insert</operation>
  <object>Contact</object>
  <concurrencyMode>Serial</concurrencyMode>
  <contentType>CSV</contentType>
</jobInfo>
    eos

    job = Salesforklift::Job.new("cs1-api", "fake_session_id", "Contact", :insert)
    job.generate_create_request.should eq expected
  end

  it "generates job request with external_id" do
    expected = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<jobInfo xmlns="http://www.force.com/2009/06/asyncapi/dataload">
  <operation>upsert</operation>
  <object>Contact</object>
  <externalIdFieldName>GCUserId__c</externalIdFieldName>
  <concurrencyMode>Serial</concurrencyMode>
  <contentType>CSV</contentType>
</jobInfo>
    eos

    job = Salesforklift::Job.new("cs1-api", "fake_session_id", "Contact", :upsert, "GCUserId__c")
    job.generate_create_request.should eq expected
  end

  it "Job can be created" do
    fake_sf_response = <<-eos
<?xml version="1.0" encoding="UTF-8"?><jobInfo
   xmlns="http://www.force.com/2009/06/asyncapi/dataload">
 <id>750S00000000F6xIAE</id>
 <operation>insert</operation>
 <object>Contact</object>
 <createdById>005S0000000abcdef</createdById>
 <createdDate>2011-08-01T21:01:16.000Z</createdDate>
 <systemModstamp>2011-08-01T21:01:16.000Z</systemModstamp>
 <state>Open</state>
 <concurrencyMode>Parallel</concurrencyMode>
 <contentType>CSV</contentType>
 <numberBatchesQueued>0</numberBatchesQueued>
 <numberBatchesInProgress>0</numberBatchesInProgress>
 <numberBatchesCompleted>0</numberBatchesCompleted>
 <numberBatchesFailed>0</numberBatchesFailed>
 <numberBatchesTotal>0</numberBatchesTotal>
 <numberRecordsProcessed>0</numberRecordsProcessed>
 <numberRetries>0</numberRetries>
 <apiVersion>21.0</apiVersion>
 <numberRecordsFailed>0</numberRecordsFailed>
 <totalProcessingTime>0</totalProcessingTime>
 <apiActiveProcessingTime>0</apiActiveProcessingTime>
 <apexProcessingTime>0</apexProcessingTime>
</jobInfo>
    eos

    http_response = double("http_response")
    mock_http = mock("mock_http")
    Net::HTTP.stub(:new).and_return(mock_http)
    mock_http.stub(:use_ssl=)
    mock_http.stub(:post).and_return(http_response)
    http_response.stub(:class).and_return(Net::HTTPCreated)
    http_response.stub(:body).and_return(fake_sf_response)

    job = Salesforklift::Job.new("cs1-api", "fake_session_id", "Contact", :insert)
    job.create()
    job.sf_job_id.should eq "750S00000000F6xIAE"
  end

  it "closes job" do
    http_response = double("http_response")
    mock_http = mock("mock_http")
    Net::HTTP.stub(:new).and_return(mock_http)
    mock_http.stub(:use_ssl=)
    mock_http.stub(:post).and_return(http_response)
    http_response.stub(:class).and_return(Net::HTTPOK)

    job = Salesforklift::Job.new("cs1-api", "fake_session_id", "Contact", :insert)
    job.close.should be_true
  end
end
