require 'rexml/document'

module Salesforklift

  class LoginResponse

    attr_accessor :server_instance, :session_id, :server_url

    def initialize(session_id, server_url)
      @session_id = session_id
      @server_url = server_url
      if /(https:\/\/)(.+)(.salesforce.com)(.*)/.match(@server_url)
        @server_instance = $2
      end
    end
    
    def self.fromXML(xml)
      doc = REXML::Document.new(xml)
      LoginResponse.new(doc.elements['//sessionId'].text, doc.elements["//serverUrl"].text)
    end
  end

end
