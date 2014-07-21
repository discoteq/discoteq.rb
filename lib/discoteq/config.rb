module Discoteq
  # encapsulate the special needs of discoteq configuration
  class Config < Hash
    def []=(k, v)
      super
      @prepared = false
    end

    def prepared?
      @prepared ||= false
    end

    def prepare!
      unless prepared?
        if self['chef']
          require_relative 'chef'
          Discoteq::Chef::Config.new(self['chef'])
        end
        @prepared = true
      end
      self
    end
  end
end
