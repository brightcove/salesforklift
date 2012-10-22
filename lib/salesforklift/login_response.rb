require 'rexml/document'

module Salesforklift

  class LoginResponse

    attr_accessor :server_instance, :session_id, :server_url

    def self.fromXML(xml)
      doc = REXML::Document.new(xml)

      response = LoginResponse.new
      response.server_url = doc.elements["//serverUrl"].text

      if /(https:\/\/)(.+)(.salesforce.com)(.*)/.match(response.server_url)
        response.server_instance = $2
      end
      response.session_id = doc.elements['//sessionId'].text
      response
    end
  end

end
