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
      batch_content = ""
      File.open(data_file, "r") do |infile|
        while (line = infile.gets)
          batch_content += line
        end
      end

      logger.debug batch_content
      create(batch_content)
    end

    def create(batch_content)
      response = RestClient.post("https://#{@server_instance}.salesforce.com/services/async/21.0/job/#{@sf_job_id}/batch",
                                 batch_content.lstrip,
                                {"Content-Type" => "text/csv;charset=UTF-8", "X-SFDC-Session" => @session_id})
      return false if (response.code/100 != 2)
      response = BatchResponse.fromXML(response.body)
      @batch_id = response.batch_id
    end

    def query_status
      http = Net::HTTP.new("#{@server_instance}.salesforce.com", 443)
      http.use_ssl = true

      response = http.get("/services/async/21.0/job/#{@sf_job_id}/batch/#{@batch_id}",
                          {"X-SFDC-Session" => @session_id})

      return response.body if response.class != Net::HTTPOK

      return BatchResponse.fromXML(response.body)
    end

    def query_result
      http = Net::HTTP.new("#{@server_instance}.salesforce.com", 443)
      http.use_ssl = true

      response = http.get("/services/async/21.0/job/#{@sf_job_id}/batch/#{@batch_id}/result",
                          {"X-SFDC-Session" => @session_id})
      return response.body if response.class != Net::HTTPOK

      result = Array.new
      response.body.each_line do |line|
        one_record = line.split(",")
        result << {:id => one_record[0], :success => one_record[1],
                   :created => one_record[2], :error => one_record[3]}
      end

      result.drop(1)  # drop header
    end

  end

end
