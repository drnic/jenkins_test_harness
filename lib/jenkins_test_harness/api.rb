module JenkinsTestHarness
  class Api
    class CannotReconnect < StandardError; end

    # Creates a global JenkinsApi::Client object (accessed via `.api`)
    # Immediately tests the parameters provided that
    # actually reference a running Jenkins server, and
    # that the user can be authenticated
    def self.connect(config)
      @api = JenkinsApi::Client.new(config)
      @api.api_get_request("/", nil, "")
    end

    def self.api
      @api
    end
  end
end