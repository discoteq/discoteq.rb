cookbook_file("#{Chef::Config[:file_cache_path]}/discoteq.gem") do
end.run_action(:create)

chef_gem 'discoteq' do
  source "#{Chef::Config[:file_cache_path]}/discoteq.gem"
  action :upgrade
end

require 'chef/discoteq'

Discoteq.config = JSON.load <<EOJ
{
  "query_map": {
    "myface-fascade": {
      "type": "explicit",
      "records": [
        {
          "hostname": "myface-lb.example.net"
        }
      ]
    },
    "myface": {
      "type": "explicit",
      "records": [
       {
          "hostname": "myface.example.net",
          "port": 8080
        }
      ]
    },
    "myface-cache": {
      "type": "chef_role"
    }
  }
}
EOJ

services = service_disco %w(myface myface-cache)

file '/etc/myface.json' do
  content "#{{services: services}.to_json}\n"
end
