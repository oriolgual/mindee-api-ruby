[![License: MIT](https://img.shields.io/github/license/mindee/mindee-api-ruby)](https://opensource.org/licenses/MIT) [![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/mindee/mindee-api-ruby/test.yml)](https://github.com/mindee/mindee-api-ruby) [![Gem Version](https://img.shields.io/gem/v/mindee)](https://rubygems.org/gems/mindee) [![Downloads](https://img.shields.io/gem/dt/mindee.svg)](https://rubygems.org/gems/mindee)

# Mindee API Helper Library for Ruby
Quickly and easily connect to Mindee's API services using Ruby.

## Requirements
The following Ruby versions are tested and supported: 2.6, 2.7, 3.0, 3.1, 3.2

## Quick Start
Here's the TL;DR of getting started.

First, get an [API Key](https://developers.mindee.com/docs/create-api-key)

Install by adding this line to your application's Gemfile:

```ruby
gem 'mindee'
```

And then execute:

    $ bundle install

Finally, Ruby away!

### Loading a File and Parsing It

#### Global Documents
```ruby
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk and parse it
result = mindee_client.doc_from_path('/path/to/the/file.ext')
  .parse(Mindee::Prediction::InvoiceV4)

# Print a full summary of the parsed data in RST format
puts result
```

#### Region-Specific Documents
```ruby
require 'mindee'

# Init a new client
mindee_client = Mindee::Client.new(api_key: 'my-api-key')

# Load a file from disk and parse it
result = mindee_client.doc_from_path('/path/to/the/file.ext')
  .parse(Mindee::Prediction::EU::LicensePlateV1)

# Print a full summary of the parsed data in RST format
puts result.document
```

### Custom Document (API Builder)
```ruby
require 'mindee'

# Init a new client and configure your custom document
mindee_client = Mindee::Client.new(api_key: 'my-api-key').add_endpoint(
  'john',
  'wnine'
)

# Load a file from disk and parse it
result = mindee_client.doc_from_path('/path/to/the/file.ext')
  .parse(Mindee::Prediction::CustomV1, endpoint_name: 'wnine')

# Print a full summary of the parsed data in RST format
puts result

# Looping over all prediction values
result.inference.prediction.fields.each do |field_name, field_data|
  puts field_name
  puts field_data.values
  puts field_data.to_s
end
```

## Further Reading
There's more to it than that for those that need more features, or want to
customize the experience.

- [Ruby Overview](https://developers.mindee.com/docs/ruby-getting-started)
- [Ruby Custom APIs OCR](https://developers.mindee.com/docs/ruby-api-builder)
- [Ruby invoices OCR](https://developers.mindee.com/docs/ruby-invoice-ocr)
- [Ruby receipts OCR](https://developers.mindee.com/docs/ruby-receipt-ocr)
- [Ruby passports OCR](https://developers.mindee.com/docs/ruby-passport-ocr)

## License
Copyright © Mindee, SA

Available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Questions?
[Join our Slack](https://join.slack.com/t/mindee-community/shared_invite/zt-1jv6nawjq-FDgFcF2T5CmMmRpl9LLptw)
