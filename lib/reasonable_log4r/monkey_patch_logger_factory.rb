module Log4r
  class Logger
    # Returns the root logger. Identical to Logger.global
    def self.root; return RootLogger.instance end
    # Returns the root logger. Identical to Logger.root
    def self.global; return GlobalLogger.instance end

    # Get a logger with a fullname from the repository or nil if logger
    # wasn't found.

    def self.[](_fullname)
      # forces creation of RootLogger if it doesn't exist yet.
      if _fullname=='root'
        return RootLogger.instance
      end
      if _fullname=='global'
        return GlobalLogger.instance
      end
      Repository[_fullname]
    end

    class LoggerFactory #:nodoc:
      # we want to log if root.lev <= lev && logger.lev <= lev
      # BTW, root is guaranteed to be defined by this point
      def self.define_methods(logger)
        undefine_methods(logger)
        globlev = Log4r::Logger['global'].level
        return if logger.level == OFF or globlev == OFF
        toggle_methods(globlev, logger)
      end

      # Logger logging methods are defined here.
      def self.set_log(logger, lname)
        # invoke caller iff the logger invoked is tracing
        tracercall = (logger.trace ? "caller" : "nil")
        # maybe pass parent a logevent. second arg is the switch
        if logger.additive && !logger.is_root?
          parentcall = "@parent.#{lname.downcase}(event, true)"
        end
        mstr = %-
          def logger.#{lname.downcase}(data=nil, propagated=false)
            if propagated then event = data
            else
              data = yield if block_given?
              event = LogEvent.new(#{lname}, self, #{tracercall}, data)
            end
            @outputters.each {|o| o.#{lname.downcase}(event) }
            #{parentcall}
          end
        -
        module_eval mstr
      end
    end
  end
end