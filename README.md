# Envme [![Gem Version](https://badge.fury.io/rb/envme.svg)](http://badge.fury.io/rb/envme) [![Circle CI](https://circleci.com/gh/reppard/envme.svg?style=svg)](https://circleci.com/gh/reppard/envme)

Envme is a Ruby wrapper around hashicorp's [envconsul](https://github.com/hashicorp/envconsul).  It fetches k/v data from Consul using a user specified prefix which can then be used to configure your app with the returned enviroment variables.  It can be useful for building AWS user data or generating systemd service files.

## Installation
  
  $ gem install envme

Or add to your Gemfile

```ruby
source 'https://rubygems.org'

gem 'envme',  '>=0.1.2'
```

## Usage
### Configuration

```ruby
  Envme.configure do |config|
    config.url = "localhost:8500"
    config.acl_token =  "xxxxxxxx-yyyy-zzzz-1111-222222222222"
  end
```

### Get all at specified prefix

```ruby
Envme::Vars.get_all('test/prefix')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser", "REST_ENDPOINT=rest.endpoint.com"]
```

### Get limited by using a search string

```ruby
Envme::Vars.get_limited('test/prefix', 'rest')
=> ["REST_ENDPOINT=rest.endpoint.com"]

Envme::Vars.get_limited('test/prefix', 'db')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser"]

# Using multiple search strings

Envme::Vars.get_limited('test/prefix', 'db', 'rest')
=> ["DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser", "REST_ENDPOINT=rest.endpoint.com", "DB_ENDPOINT=db.endpoint.com"]
```

### Sanitizing return values

```ruby
vars = Envme::Vars.get_limited('test', 'db')
=> ["PREFIX_DB_ENDPOINT=db.endpoint.com", "PREFIX_DB_PASSWD=p@s$W0rd", "PREFIX_DB_USERNAME=dbuser"]

Envme::Vars.sanitize(vars, 'prefix')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser"]
```

### Building exports and File builder scripts

```ruby
vars = Envme::Vars.get_limited('test/prefix', 'db')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser"]

puts Envme.build_exports(vars)

export DB_ENDPOINT=db.endpoint.com
export DB_PASSWD=p@s$W0rd
export DB_USERNAME=dbuser


# Build a script to populate a systemd EnvironmentFile

puts Envme.file_builder(vars, '/etc/sysconfig/my_service.service')

echo DB_ENDPOINT=db.endpoint.com >> /etc/sysconfig/my_service.service
echo DB_PASSWD=p@s$W0rd >> /etc/sysconfig/my_service.service
echo DB_USERNAME=dbuser >> /etc/sysconfig/my_service.service
```

Inspired by [Diplomat](https://github.com/WeAreFarmGeek/diplomat)
