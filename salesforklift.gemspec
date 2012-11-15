Gem::Specification.new do |s|
  s.authors = "Max Mao"
  s.email = "jmao@brightcove.com"
  s.name = "salesforklift"
  s.summary = "Salesforce Bulk API ruby wrapper"
  s.description = "Salesforce Bulk API ruby wrapper."
  s.files = Dir["{app,lib,config}/**/*"] + ["Rakefile", "Gemfile", "README.md"]
  s.version = "0.0.8"

  s.add_runtime_dependency "rest-client"
end
