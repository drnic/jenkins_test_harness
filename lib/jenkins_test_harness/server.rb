module JenkinsTestHarness
  # Control a Jenkins server to start/stop for integration testing
  class Server
    def version
      Jenkins::War::VERSION
    end
  end
end
