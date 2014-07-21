# Discoteq

Discoteq discovers the URIs, hostnames, ports, and other details that
your app needs to access the services it depends on.

To do that, it gives you a flexible way to define the services and
resources that an app needs to run in a reusable way.

This lets you DRY out service configs so that fundamental facts about a
service aren't defined in more than one place.

The simplest thing that could possibly work
-------------------------------------------

    gem install discoteq
    cat >/etc/discoteq-chef.json <<EOF
    {
        "services": {
            "myface-fascade": {
                "role": "myface-lb"
            },
            "myface": {
                "role": "myface"
            },
            "myface-db-master": {
                "query": "role:myface-db AND tag:master"
            },
            "myface-db-slave": {
                "query": "role:myface-db AND tag:slave"
            },
            "myface-cache": {
                "role": "myface-cache"
            },
            "statsd": {
                "role": "statsd",
                "include_chef_environment": false,
                "attrs": {
                    "hostname": "cloud.private_ipv4",
                    "port": "statsd.port"
                }
            }
        }
    }
    EOF
    
    discoteq < /etc/discoteq-chef.json >  /var/lib/discoteq/services.json
    cat /var/lib/discoteq/services.json
    {
        "services": {
            "myface-fascade": [
                {
                    "hostname": "myface-lb.example.net"
                }
            ],
            "myface": [
                {
                    "hostname": "myface-001.example.net"
                }
            ],
            "myface-db-master": [
                {
                    "hostname": "myface-db-001.example.net"
                }
            ],
            "myface-db-slave": [
                {
                    "hostname": "myface-db-002.example.net"
                },
                {
                    "hostname": "myface-db-003.example.net"
                }
            ],
            "myface-cache": [
                {
                    "hostname": "myface-cache-001.example.net"
                }
            ],
            "statsd": [
                {
                    "hostname": "10.0.0.216",
                    "port": 8126
                }
            ]
        }
    }


As you can see, you just need to drop a config file, run `discoteq` with
an output file, and it will populate the file with the host attributes
you need.

## Using Inside `chef`

To use discoteq inside chef, you need to install the gem, include the chef helpers, and then query for the services you'd like.

```ruby
chef_gem 'discoteq'
include 'chef/discoteq'

services = service_disco %w(my_db my_cache my_queue)

file '/etc/my/config.json' do
  content services.to_json
end
```

### Template Usage

Probably the first thing you'll want to do is expose these services to
the `template` resources for the apps you're configuring.

With a recipe like:

```ruby
services = service_disco %w(my_db_primary my_db_replica my_cache my_queue_facade)

template '/etc/my/config.conf' do
  source 'config.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables services: services
end
```

with an accompanying `config.conf.erb` like:

```erb
database_primary {
  type mysql
  hostname <%= @services['my_db_primary'][0]['hostname'] %>
  port <%= @services['my_db_primary'][0]['port'] %>
}
database_replicas {
  <% @services['my_db_replica'].each do |replica| %>
  <%= replica['hostname'] %> {
    type mysql
    hostname <%= replica['hostname'] %>
    port <%= replica['port'] %>
  }
  <% end %>
}
cache {
  <% @services['my_db_cache'].each do |cache| %>
  <%= cache['hostname'] %> {
    type memcached
    hostname <%= cache['hostname'] %>
    port <%= cache['port'] %>
  }
  <% end %>
}
queue {
  type rabbitmq
  url 'amqp://<%= @services['my_queue'][0]['hostname'] %>:<%= @services['my_queue'][0]['port'] %>'
}
```

### Serializing to JSON using the `file` Resource

For greenfield or internal projects that can take a custom config 
format, you may want to skip all the templating and export all services
found via `service_disco` into a simple JSON file. Of course, this
is easy:

```ruby
services = service_disco %w(my_db my_cache my_queue)

file '/etc/my/config.json' do
  content services.to_json
  owner 'root'
  group 'root'
  mode '0644'
end
```

Now all the services are dropped into `/etc/my/config.json` for
easy access.

This is especially useful as a migration step to using the stand-alone `discoteq` binary outside chef.

### Direct Access within Recipes

Sometimes your cookbooks need to be really smart(tm), and you'll want
to access your services from other resources in your cookbook. For
example, here is an example of using discoteq with the
[`database`](https://github.com/opscode-cookbooks/database) cookbook.

Note we use `#fetch` instead of `#[]` so that an error will be raised if no value is found.

```ruby
# Pull in the service map via service discovery
services = service_disco %w(myface_db_master)
# Grab the first host record from the myface_db_master service
db = services['myface_db_master'][0]

mysql_connection_info = {
  host: db.fetch('hostname'),
  username: db.fetch('username'),
  password: db.fetch('server_root_password')
}

# Create the database
mysql_database 'myface' do
  connection mysql_connection_info
  action :create
end

# Create user and grant privileges to the database
# for clients on the allowed hosts and networks
mysql_database_user "myface@app" do
  connection mysql_connection_info
  database_name 'myface'
  username 'myface-app'
  password 's3kr3t'
  privileges [:all]
  action [:create,:grant]
end
```

## Templating from JSON

Of course, your app probably doesn't expect its services in the format
discoteq provides. Perhaps you're currently using chef to populate a
config file using ERB, and it seems awefully inconvenient to have to
change your app to accomidate this tool.

Fear not! The ubiquitous Erubis templating language ships with a
templater that will handle your needs! The only caveat is that it
really insists that its context data be in YAML. Fortunately, JSON is a
subset of YAML so we only need to output into a file ending in `.yaml`.

```sh
discoteq -c /etc/discoteq.conf > /etc/myface.yml
erubis -f /etc/myface.yml myface-template.erb > $APP/myface.config
```

## Project Principles

* Community: If a newbie has a bad time, it's a bug.
* Software: Make it work, then make it right, then make it fast.
* Technology: If it doesn't do a thing today, we can make it do it tomorrow.

## Contributing

Got an idea? Something smell wrong? Cause you pain? Or lost seconds of your life you'll never get back?

All contributions are welcome: ideas, patches, documentation, bug 
reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open
source and maintainers or community members  saying "send patches or 
die" - you will not see that here.

It is more important to me that you are able to contribute.

(Some of the above was repurposed with <3 from logstash)
