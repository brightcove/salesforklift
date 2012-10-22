require 'spec_helper'

describe Salesforklift::BatchResponse do

  it "parses Batch XML response" do
    http_response = <<-eos
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

    batch_response = Salesforklift::BatchResponse.fromXML(http_response)
    batch_response.batch_id.should eq("751S00000002tkrIAA")
  end
end
