require 'rexml/document'

module Salesforklift

  class BatchResponse
    attr_accessor :batch_id, :state

    def self.fromXML(xml)
      doc = REXML::Document.new(xml)

      response = BatchResponse.new
      response.batch_id = doc.elements['//id'].text
      response.state = doc.elements['//state'].text
      response
    end
  end

end
