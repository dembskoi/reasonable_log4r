require 'log4r/logger'
require 'log4r/yamlconfigurator'

module Log4r
  class RootLogger < Logger
    def initialize
      Log4r.define_levels(*Log4rConfig::LogLevels) # ensure levels are loaded
      @level = ALL
      @outputters = []
      Repository['root'] = self
      LoggerFactory.define_methods(self)
    end

    def is_root?; true end

    # Set the global level. Any loggers defined thereafter will
    # not log below the global level regardless of their levels.

    def level=(alevel); @level = alevel end

    # Does nothing
    def additive=(foo); end

    def outputters=(foo)
      super
    end
    def trace=(foo)
      super
    end
    def add(*foo)
      super
    end
    def remove(*foo)
      super
    end
  end

  class GlobalLogger < Logger
    include Singleton

    def initialize
      Log4r.define_levels(*Log4rConfig::LogLevels) # ensure levels are loaded
      @level = ALL
      @outputters = []
      Repository['global'] = self
      LoggerFactory.undefine_methods(self)
    end

    def is_root?; true end

    # Set the global level. Any loggers defined thereafter will
    # not log below the global level regardless of their levels.

    def level=(alevel); @level = alevel end

    # Does nothing
    def outputters=(foo); end
    # Does nothing
    def trace=(foo); end
    # Does nothing
    def additive=(foo); end
    # Does nothing
    def add(*foo); end
    # Does nothing
    def remove(*foo); end
  end
end
