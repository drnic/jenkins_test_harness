module JenkinsTestHarness
  # Control a Jenkins server to start/stop for integration testing
  class Server
    def initialize(attributes={})
      attributes[:port] ||= 3001
      attributes[:control] ||= attributes[:port] + 1
      @attributes = attributes
    end

    def port; @attributes[:port]; end
    def control; @attributes[:control]; end
    def version; Jenkins::War::VERSION; end

    def start
      
    end

    def stop
    end

    def running?
      true
    end
  end
end
