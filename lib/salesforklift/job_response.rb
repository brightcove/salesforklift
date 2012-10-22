require 'rexml/document'

module Salesforklift

  class JobResponse
    attr_accessor :job_id

    def self.fromXML(xml)
      doc = REXML::Document.new(xml)

      response = JobResponse.new
      response.job_id = doc.elements['//id'].text
      response
    end

  end
end
