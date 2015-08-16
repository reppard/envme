# Envme [![Gem Version](https://badge.fury.io/rb/envme.svg)](http://badge.fury.io/rb/envme) [![Circle CI](https://circleci.com/gh/reppard/envme.svg?style=svg)](https://circleci.com/gh/reppard/envme)

Envme is a Ruby wrapper around hashicorp's [envconsul](https://github.com/hashicorp/envconsul).  It fetches k/v data from Consul using a user specified prefix which can then be used to configure your app with the returned enviroment variables.  It can be useful for building AWS user data or generating systemd service files.  Currently works with envconsul v0.5.0.

## Installation
  
```shell
$ gem install envme
```

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

### Get

Grab everything at specified prefix:

```ruby
Envme::Vars.get('test/prefix')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser", "REST_ENDPOINT=rest.endpoint.com"]
```

Limit return by passing in a search string:

```ruby
Envme::Vars.get('test/prefix', 'rest')
=> ["REST_ENDPOINT=rest.endpoint.com"]

Envme::Vars.get('test/prefix', 'db')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser"]
```

Using multiple search strings:

```ruby
Envme::Vars.get('test/prefix', 'db', 'rest')
=> ["DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser", "REST_ENDPOINT=rest.endpoint.com", "DB_ENDPOINT=db.endpoint.com"]
```

### Sanitizing return values

```ruby
vars = Envme::Vars.get('test', 'db')
=> ["PREFIX_DB_ENDPOINT=db.endpoint.com", "PREFIX_DB_PASSWD=p@s$W0rd", "PREFIX_DB_USERNAME=dbuser"]

Envme::Vars.sanitize(vars, 'prefix')
=> ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser"]
```

### Building scripts

Exports for script:

```ruby
vars = Envme::Vars.get('test/prefix', 'db')
# => ["DB_ENDPOINT=db.endpoint.com", "DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser"]

exports = Envme.build_exports(vars)
# => "export DB_ENDPOINT=db.endpoint.com\nexport DB_PASSWD=p@s$W0rd\nexport DB_USERNAME=dbuser"

start_script = <<-eos
#!/bin/bash
#{exports}
ruby app.rb
eos
# => "#!/bin/bash\nexport DB_ENDPOINT=db.endpoint.com\nexport DB_PASSWD=p@s$W0rd\nexport DB_USERNAME=dbuser\nruby app.rb\n"

puts start_script

#!/bin/bash
export DB_ENDPOINT=db.endpoint.com
export DB_PASSWD=p@s$W0rd
export DB_USERNAME=dbuser
ruby app.rb
=> nil
```

Populate a systemd EnvironmentFile:

```ruby
vars = Envme::Vars.get('test/prefix', 'rest', 'db')
# => ["DB_PASSWD=p@s$W0rd", "DB_USERNAME=dbuser", "REST_ENDPOINT=rest.endpoint.com", "DB_ENDPOINT=db.endpoint.com"]

file_builder = Envme.file_builder(vars, '/etc/sysconfig/my_service.service')
# => "echo DB_ENDPOINT=db.endpoint.com >> /etc/sysconfig/my_service.service\necho DB_PASSWD=p@s$W0rd >> /etc/sysconfig/my_service.service\necho DB_USERNAME=dbuser >> /etc/sysconfig/my_service.service\necho REST_ENDPOINT=rest.endpoint.com >> /etc/sysconfig/my_service.service"

user_data = <<-eos
#!/bin/bash
#{file_builder}
systemctl my_service start
eos
=> "#!/bin/bash\necho DB_ENDPOINT=db.endpoint.com >> /etc/sysconfig/my_service.service\necho DB_PASSWD=p@s$W0rd >> /etc/sysconfig/my_service.service\necho DB_USERNAME=dbuser >> /etc/sysconfig/my_service.service\necho REST_ENDPOINT=rest.endpoint.com >> /etc/sysconfig/my_service.service\nsystemctl my_service start\n"

puts user_data

#!/bin/bash
echo DB_ENDPOINT=db.endpoint.com >> /etc/sysconfig/my_service.service
echo DB_PASSWD=p@s$W0rd >> /etc/sysconfig/my_service.service
echo DB_USERNAME=dbuser >> /etc/sysconfig/my_service.service
echo REST_ENDPOINT=rest.endpoint.com >> /etc/sysconfig/my_service.service
systemctl my_service start
=> nil
```

Inspired by [Diplomat](https://github.com/WeAreFarmGeek/diplomat)
