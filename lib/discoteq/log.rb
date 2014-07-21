# ensure logs get to a reasonable place
module Discoteq
  # Logger encapsulates hooking up logging to reasonable outputs
  module Logger
    LOGGING_TECHNIQUES = %w(
      nil
      chef
      stderr
      stdout
      syslog
    )

    def self.build(type = 'stderr')
      unless LOGGING_TECHNIQUES.include? type
        fail ArgumentError, 'Logger type must be in ' \
          "#{LOGGING_TECHNIQUES.inspect}, was: #{type}"
      end
      send(type.to_sym)
    end

    def self.nil(*_)
      @nil ||= NilLogger.new
    end

    def self.stderr(*_)
      require 'logger'
      @stderr ||= ::Logger.new STDERR
    end

    def self.stdout
      require 'logger'
      @stdout ||= ::Logger.new STDOUT
    end

    def self.syslog
      require 'syslog/logger'
      @syslog ||= Syslog::Logger.new 'discoteq'
    end

    def self.chef
      require 'chef/log'
      @cheflog ||= Chef::Log
    end
  end

  # Logger which accepts every method call and does nothing
  class NilLogger
    def method_missing(*_, &_blk)
      # nop
    end
  end

  # Yes, this is a global
  Log = Logger.build
end
