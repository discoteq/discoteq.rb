require 'chef/config'

module Discoteq
  module Chef
    # Config contains all the information required to connect to a chef
    # server and make sensible queries
    class Config < Hash
      def initialize(opts)
        # FIXME: these are hardcoded
        ::Chef::Config.from_file('/dev/null')
        if opts['client_name']
          ::Chef::Config[:node_name] = opts['client_name']
        end
        if opts['server_url']
          ::Chef::Config[:chef_server_url] = opts['server_url']
        end
        ::Chef::Config[:log_level] = :debug
      end
    end
  end
end
