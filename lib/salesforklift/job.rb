require 'net/http'
require 'uri'

module Salesforklift

  class Job
    include Salesforklift::Logging

    attr_accessor :server_instance, :session_id, :sf_object, :sf_action,
                  :sf_format, :sf_job_id, :external_id, :concurrency_mode

    def initialize(server_instance, session_id, sf_object, sf_action,
        external_id = nil, sf_format = :CSV, concurrency_mode = :Serial)
      @server_instance = server_instance
      @session_id = session_id
      @sf_object = sf_object
      @sf_action = sf_action
      @sf_format = sf_format
      @external_id = external_id
      @concurrency_mode = concurrency_mode
    end

    def generate_create_request
      request = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<jobInfo xmlns="http://www.force.com/2009/06/asyncapi/dataload">
  <operation>#{@sf_action}</operation>
  <object>#{@sf_object}</object>
      eos

      if @external_id
        request += <<-eos
  <externalIdFieldName>#{@external_id}</externalIdFieldName>
        eos
      end

      request += <<-eos
  <concurrencyMode>#{@concurrency_mode.to_s}</concurrencyMode>
  <contentType>#{@sf_format.to_s}</contentType>
</jobInfo>
      eos
    end

    def generate_close_request
      request = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<jobInfo xmlns="http://www.force.com/2009/06/asyncapi/dataload">
  <state>Closed</state>
</jobInfo>
      eos
    end

    # Create a Salesforce Job
    def create
      http = Net::HTTP.new("#{@server_instance}.salesforce.com", 443)
      http.use_ssl = true

      job_request = generate_create_request.lstrip
      logger.debug job_request
      response = http.post('/services/async/21.0/job',
                              job_request,
                              {"Content-Type" => "application/xml;charset=UTF-8", "X-SFDC-Session" => @session_id})

      return response.body if response.class != Net::HTTPCreated

      job_response = JobResponse.fromXML(response.body)
      @sf_job_id = job_response.job_id
      job_response
    end

    def close
      http = Net::HTTP.new("#{@server_instance}.salesforce.com", 443)
      http.use_ssl = true

      response = http.post("/services/async/21.0/job/#{@sf_job_id}",
                            generate_close_request.lstrip,
                            {"Content-Type" => "application/xml;charset=UTF-8", "X-SFDC-Session" => @session_id})
      return response.class == Net::HTTPOK
    end
  end
end
