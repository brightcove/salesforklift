require 'net/http'
require 'uri'

module Salesforklift
  class Login
    include Salesforklift::Logging

    def login_sforce(user, pass, url)
      loginRequest = <<-eos
        <?xml version="1.0" encoding="utf-8" ?>
        <env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
          <env:Body>
            <n1:login xmlns:n1="urn:partner.soap.sforce.com">
              <n1:username>#{user}</n1:username>
              <n1:password>#{pass}</n1:password>
            </n1:login>
          </env:Body>
        </env:Envelope>
        eos

      http = Net::HTTP.new(url, 443)
      http.use_ssl = true

      response = http.post('/services/Soap/u/21.0',
                              loginRequest.lstrip,
                              {"Content-Type" => "text/xml;charset=UTF-8", "SOAPAction" => "login"})
      
      return false if response.class != Net::HTTPOK

      return LoginResponse.fromXML(response.body)
    end
    
  end
end
