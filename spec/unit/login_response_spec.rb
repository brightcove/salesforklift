require 'spec_helper'

describe Salesforklift::LoginResponse do
  it "parses Login Response" do
    raw_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns="urn:partner.soap.sforce.com"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <soapenv:Body>
    <loginResponse>
      <result>
        <metadataServerUrl>https://cs1-api.salesforce.com/services/Soap/m/21.0/00DS00000005aKF</metadataServerUrl>
        <passwordExpired>false</passwordExpired><sandbox>true</sandbox>
        <serverUrl>https://cd1-api.salesforce.com/services/Soap/u/21.0/00DS00000016aKF</serverUrl>
        <sessionId>00DS00000005aKF!ARUAQLa3mjWjna4plI4wV3LE.g0MIwqfJuHadPK7wJsQOMSo99tbz21XoAGUxGs.lfpvzBIuMjLfy_05xj2S5roNW23doBwi</sessionId>
        <userId>005S0000000abcdef</userId>
        <userInfo>
          <accessibilityMode>false</accessibilityMode>
          <currencySymbol>$</currencySymbol><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit>
          <orgDefaultCurrencyIsoCode>USD</orgDefaultCurrencyIsoCode><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments>
          <orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00DS00000005aKJUNE</organizationId>
          <organizationMultiCurrency>false</organizationMultiCurrency><organizationName>GreatCorp</organizationName>
          <profileId>00e30000000ec2hAAA</profileId><roleId>00E30000000iMMSEA2</roleId>
          <sessionSecondsValid>14400</sessionSecondsValid><userDefaultCurrencyIsoCode xsi:nil="true"/>
          <userEmail>jmao@greatcorp.com</userEmail><userFullName>GreatCorp testing</userFullName>
          <userId>005S0000000abcdef</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale>
          <userName>jmao@greatcorp.com.salesforce</userName><userTimeZone>America/Indianapolis</userTimeZone>
          <userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo>
      </result>
    </loginResponse>
  </soapenv:Body>
</soapenv:Envelope>
    eos

    login = Salesforklift::LoginResponse.fromXML(raw_xml)
    login.server_instance.should eq("cd1-api")
    login.session_id.should eq "00DS00000005aKF!ARUAQLa3mjWjna4plI4wV3LE.g0MIwqfJuHadPK7wJsQOMSo99tbz21XoAGUxGs.lfpvzBIuMjLfy_05xj2S5roNW23doBwi"
  end
end
