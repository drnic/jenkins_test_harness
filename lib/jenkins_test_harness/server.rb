module JenkinsTestHarness
  # Control a Jenkins server to start/stop for integration testing
  #
  # Usage:
  #   server = JenkinsTestHarness::Server.new(port: 3333)
  #   server.start # blocks until fully running
  #
  # Now access API to server via:
  #   JenkinsTestHarness::Api.api
  class Server
    include JenkinsTestHarness::Api::Helpers

    # Options:
    # :port - port to access Jenkins
    # :control - control port to control Jenkins
    # :daemon - fork into background and run as a daemon (default: true)
    # :kill - send shutdown signal to control port (default: false)
    # :home - use this parent directory to store server data (default: $HOME/.jenkins/server)
    # :logfile - redirect log messages to this file (optional: $HOME/.jenkins/server/jenkins.log)
    def initialize(attributes={})
      attributes[:port] ||= 3001
      attributes[:control] ||= attributes[:port] + 1
      attributes[:daemon] ||= attributes[:daemon].nil? ? true : attributes[:daemon]
      attributes[:home] ||= File.join(ENV['HOME'], ".jenkins", "server")
      attributes[:logfile] ||= File.join(attributes[:home], "jenkins.log")
      @attributes = attributes
    end

    # ports to access Jenkins
    def port; @attributes[:port]; end
    def control; @attributes[:control]; end

    def version; Jenkins::War::VERSION; end

    def start
      war_config         = OpenStruct.new
      war_config.port    = port
      war_config.control = control
      war_config.daemon  = @attributes[:daemon]
      war_config.kill    = @attributes[:kill]
      war_config.logfile = @attributes[:logfile]
      war_config.home    = @attributes[:home]

      Jenkins::War::server(war_config)

      wait_for_server_start
    end

    def stop
      TCPSocket.open("localhost", control) do |sock|
        sock.write("0")
      end
    end

    def running?
      true
    end

    # Returns Hash that can be passed to +JenkinsTestHarness::Api.connect(...)+
    def api_config
      {
        "server_ip"   => "localhost",
        "server_port" => port.to_s
      }
    end

    def wait_for_server_start
      tries = 1
      max_tries = 30
      successes = 0
      max_successes = 2
      wait = 5
      print "Waiting for the server to start (max tries: #{max_tries} with a #{wait} second pause between tries): "
      begin
        while tries <= max_tries
          tries += 1
          begin
            JenkinsTestHarness::Api.connect(api_config)
            print "o"
          rescue Errno::ECONNREFUSED
            print "."
            successes = 0
            if tries == max_tries
              raise
            end
          end
          sleep(wait)
        end
      ensure
        puts # Ensure a newline gets added
        $stdout.flush
      end
      return false
    end
  end
end
