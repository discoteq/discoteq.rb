- See code for TODO & FIXME
- cap2 integration

```ruby
# Capistrano 2.0 helper for discovering hosts. Additional attributes are
# ignored since capistrano has no good way of using them.
#
# Usage:
#
#   require 'discoteq/capistrano'
#
#   service_role :app, %w(myface myface-worker)
#   service_role :web, %w(myface)
#   service_role :work, %w(myface-worker)

require 'discoteq'

Capistrano::Configuration.instance(:must_exist).load do
  # select the hostname of each member of the service
  def service_hosts(service_id)
    records = Discoteq.service_map.fetch service_id
    records.map {|r| r['hostname']}
  end

  # accepts a role name and an array of service ids, and creates a
  # capistrano role with the role name and members all provided services
  def service_role(role_name, *service_ids)
    role(role_name) do
      service_ids.flat_map {|cr| service_hosts cr}
    end
  end

  # push at least the query map into config, as well as
  # chef_server_url, chef_client_name & chef_key if provided
  # def configure
  # end
end
```

- cap3 integration

```ruby
# Capistrano 3.0 helper for discovering hosts. Additional attributes are
# ignored since capistrano has no good way of using them.
#
# Usage:
#
#   require 'discoteq/capistrano'
#
#   service_role :app, %w(myface myface-worker)
#   service_role :web, %w(myface)
#   service_role :work, %w(myface-worker)

require 'discoteq'

# select the hostname of each member of the service
def service_hosts(service_id)
  records = Discoteq.service_map.fetch service_id
  records.map {|r| r['hostname']}
end

# accepts a role name and an array of service ids, and creates a
# capistrano role with the role name and members all provided services
def service_role(role_name, *service_ids)
  records = Discoteq.service_map.fetch service_id
  records.each do |r|
    server r['hostname'], r.merge(roles: [role_name]
  end
end



# push at least the query map into config, as well as
# chef_server_url, chef_client_name & chef_key if provided
# def configure
# end
```
- document other templating systems (go `text/template`, python `jinja`, mustache)
