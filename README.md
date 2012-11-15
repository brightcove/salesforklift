#salesforklift

## A Salesforce Bulk API Ruby Wrapper

Salesforce provides Bulk API to ease massive data synchronization from a data store to salesforce. This project provides a gem to use Salesforce Bulk API in a ruby app.


## Install
gem install salesforklift

## How to build salesforklift gem (usually you don't need to)
To build a gem, run ¡®gem build salesforklift.gemspec

## How to use salesforklift gem

```ruby
require 'salesforklift'

# login
login = Salesforklift::Login.new
result = login.login_sforce(TEST_USER_NAME, TEST_USER_PW, TEST_LOGIN_URL)    

# create a job to bulk insert Contact objects    
job = Salesforklift::Job.new(result.server_instance,
                          result.session_id,
                          "Contact",
                          :insert)
job.create
puts job.sf_job_id

# create batches
batch = Salesforklift::Batch.new(result.server_instance, result.session_id, job.sf_job_id)
batch.create_from_file("spec/data/contact.csv")

# close job
job.close

# check result
batch_response = batch.query_status

```

## Copyright
See LICENSE.txt for details.
