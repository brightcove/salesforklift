require 'spec_helper'

describe Salesforklift::JobResponse do
  
  it "parses Login Response" do
    raw_xml = <<-eos
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

    response = Salesforklift::JobResponse.fromXML(raw_xml)
    response.job_id.should eq("750S00000000F6xIAE")
  end
end
