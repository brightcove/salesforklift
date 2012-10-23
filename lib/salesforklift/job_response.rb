require 'rexml/document'

module Salesforklift

  class JobResponse
    attr_accessor :job_id

    def initialize(job_id)
      @job_id = job_id
    end
    
    def self.fromXML(xml)
      doc = REXML::Document.new(xml)
      JobResponse.new(doc.elements['//id'].text)
    end

  end
end
