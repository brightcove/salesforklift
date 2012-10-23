require 'restclient'

module Salesforklift

  class Batch
    include Salesforklift::Logging

    attr_accessor :server_instance, :session_id, :sf_job_id, :batch_id

    def initialize(server_instance, session_id, sf_job_id)
      @server_instance = server_instance
      @session_id = session_id
      @sf_job_id = sf_job_id
    end

    def create_from_file(data_file)
      batch_content = IO.read(data_file)
      logger.debug batch_content
      create(batch_content)
    end

    def create(batch_content)
      response = RestClient.post("https://#{@server_instance}.salesforce.com/services/async/21.0/job/#{@sf_job_id}/batch",
                                 batch_content.lstrip,
                                {"Content-Type" => "text/csv;charset=UTF-8", "X-SFDC-Session" => @session_id})
      
      if response.code / 100 == 2 # 2xx
        return (@batch_id = BatchResponse.fromXML(response.body).batch_id)
      else
        false
      end
    end

    def query_status
      http = Net::HTTP.new("#{@server_instance}.salesforce.com", 443)
      http.use_ssl = true

      response = http.get("/services/async/21.0/job/#{@sf_job_id}/batch/#{@batch_id}",
                          {"X-SFDC-Session" => @session_id})

                          
      if response.class != Net::HTTPOK
        response.body
      else
        BatchResponse.fromXML(response.body)
      end
    end

    def query_result
      http = Net::HTTP.new("#{@server_instance}.salesforce.com", 443)
      http.use_ssl = true

      response = http.get("/services/async/21.0/job/#{@sf_job_id}/batch/#{@batch_id}/result",
                          {"X-SFDC-Session" => @session_id})
      
      if response.class != Net::HTTPOK
        response.body
      else  
        response.body.lines.map do |line|
          id, success, created, error = line.split(/,/)
          {id: id, success: success, created: created, error: error}
        end.drop(1) # drop header
      end
    end

  end

end
