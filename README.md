# NDD RSpec Rails

[![Build Status](https://secure.travis-ci.org/ddidier/ndd-rspec-rails.png)](http://travis-ci.org/ddidier/ndd-rspec-rails)
[![Dependency Status](https://gemnasium.com/ddidier/ndd-rspec-rails.png)](https://gemnasium.com/ddidier/ndd-rspec-rails)
[![Code Climate](https://codeclimate.com/github/ddidier/ndd-rspec-rails/badges/gpa.svg)](https://codeclimate.com/github/ddidier/ndd-rspec-rails)
[![Test Coverage](https://codeclimate.com/github/ddidier/ndd-rspec-rails/badges/coverage.svg)](https://codeclimate.com/github/ddidier/ndd-rspec-rails/coverage)
[![Yard Documentation](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/ddidier/ndd-rspec-rails)
[![Documentation Coverage](https://inch-ci.org/github/ddidier/ndd-rspec-rails.svg)](https://inch-ci.org/github/ddidier/ndd-rspec-rails)

RSpec utilities for Rails.

The API documentation can be find at [RubyDoc](http://www.rubydoc.info/github/ddidier/ndd-rspec-rails).

## Prerequisites

This gem requires:

- `activesupport >= 4.0`
- `rspec >= 3.0`

And is tested with:

- `Ruby 2.4`
- `Ruby 2.3`
- `Ruby 2.2`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ndd-rspec-rails'
```

And then execute `bundle`

Or install it yourself with `gem install ndd-rspec-rails`

## Usage

### Controller matchers

- `have_a_translated_flash`: ensure that a flash message has an associated translation ([documentation](http://www.rubydoc.info/gems/ndd-rspec-rails/Ndd%2FRSpec%2FRails%2FMatchers%2FController:have_a_translated_flash));

### Model matchers

- `have_a_translated_attribute`: ensure that a model has an associated translation ([documentation](http://www.rubydoc.info/gems/ndd-rspec-rails/Ndd%2FRSpec%2FRails%2FMatchers%2FModel:have_a_translated_attribute));
- `have_a_translated_error`: ensure that an error on a model or an attribute has an associated translation ([documentation](http://www.rubydoc.info/gems/ndd-rspec-rails/Ndd%2FRSpec%2FRails%2FMatchers%2FModel:have_a_translated_error));
- `have_a_translated_model`: ensure that an attribute has an associated translation ([documentation](http://www.rubydoc.info/gems/ndd-rspec-rails/Ndd%2FRSpec%2FRails%2FMatchers%2FModel:have_a_translated_model));

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can 
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the 
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddidier/ndd-rspec-rails. This project is 
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the 
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

