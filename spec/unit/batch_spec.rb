require "spec_helper"

describe Salesforklift::Batch do

  it "can create batch" do
    fake_sf_response = <<-eos
<?xml version="1.0" encoding="UTF-8"?><batchInfo
   xmlns="http://www.force.com/2009/06/asyncapi/dataload">
 <id>751S00000002tkrIAA</id>
 <jobId>750S00000000FDFIA2</jobId>
 <state>Queued</state>
 <createdDate>2011-08-02T14:21:03.000Z</createdDate>
 <systemModstamp>2011-08-02T14:21:03.000Z</systemModstamp>
 <numberRecordsProcessed>0</numberRecordsProcessed>
 <numberRecordsFailed>0</numberRecordsFailed>
 <totalProcessingTime>0</totalProcessingTime>
 <apiActiveProcessingTime>0</apiActiveProcessingTime>
 <apexProcessingTime>0</apexProcessingTime>
</batchInfo>
    eos

    http_response = double("http_response")
    RestClient.stub(:post).and_return(http_response)
    http_response.stub(:code).and_return(201)
    http_response.stub(:body).and_return(fake_sf_response)

    batch = Salesforklift::Batch.new("cs1-api", "fake_session_id", "750S00000000FDFIA2")
    batch.create_from_file("spec/data/contact.csv")
    batch.batch_id.should eq("751S00000002tkrIAA")
  end
end
