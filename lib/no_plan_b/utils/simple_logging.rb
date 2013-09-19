# This is used to simply write a message to a file
# It's very very simple
# Many usage options:
#   class A
#     include NoPlanB::SimpleLogging
#     configure_simple_logger(:file => 'A.log')
#     simple_log "a log message generated by the class"
#
#     def foo
#       simple_log "a log message generated by an instance"
#     end
#   end
#
#  Or
#    class A
#      x = NoPlanB::SimpleLogger.new(:file = 'A.log',:time_stamp => true)
#      x << "This is a log message"
#    end
#    
module NoPlanB
  
  class SimpleLogger 
    attr_reader :log_file, :time_stamp, :field_sep
    
    def initialize(params={})
      p = params.dup
      @log_file = p.delete(:file) 
      @do_time_stamp = p.delete(:time_stamp)
      @field_sep = p.delete(:field_sep) || ','
      unless p.empty?
        raise "SimpleLogger: do not understand parameters : #{p.keys}"
      end
    end
    
    def <<(*notes)
      f = log_file ? File.open(log_file, "a") : STDOUT
      n = notes.inject([]) { |r,note| r << (note.is_a?(String) ? note : note.inspect) }
      @do_time_stamp ? f.puts("#{Time.now.strftime('%x %X')}: #{n*@field_sep}") : f.puts(n*@field_sep)
      f.close
    end
    alias_method :log,:<<
    
  end
    
  module SimpleLogging

    def self.included(base)
      unless base.respond_to?(:simple_log)
        base.send(:include,InstanceMethods) 
        base.send(:extend,ClassMethods) 
        # base.logger.debug "Added logger to #{base.inspect}"
      end
    end
    
    def self.configure(params)
      ClassMethods.configure_simple_logger(params)
    end
    
    module ClassMethods
      
      def configure_simple_logger(params)
        @my_logger = NoPlanB::SimpleLogger.new(params)
      end
      
      def simple_log(*args)
        _logger.log(*args)
      end
      
      private 

      def _logger
        @my_logger or raise("Please run configure_simple_logger")
      end
      
    end
    
    module InstanceMethods
      def simple_log(*args)
        self.class.simple_log(*args)
      end   
      
      def configure_logger(*args)
        self.class.configure_logger(*args)
      end   
    end

  end
end

if __FILE__ == $0
  class F
    include NoPlanB::SimpleLogging
    l = configure_simple_logger(:file => 'test')
    F.simple_log "This should fail"
    l << [{:x => 1},"b"]
  end
  F.new.simple_log("Another simple log")
  
  t = NoPlanB::SimpleLogger.new(:file => 'z.txt',:time_stamp => true,:field_sep => '--')
  t.log "This is a timestamped message",[2]
end
