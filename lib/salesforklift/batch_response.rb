require 'rexml/document'

module Salesforklift

  class BatchResponse
    attr_accessor :batch_id, :state

    def initialize(batch_id, state)
      @batch_id = batch_id
      @state = state
    end
    
    def self.fromXML(xml)
      doc = REXML::Document.new(xml)
      BatchResponse.new(doc.elements['//id'].text, doc.elements['//state'].text)
    end
  end

end
