module JenkinsTestHarness
  class Api
    class CannotReconnect < StandardError; end

    # Creates a global JenkinsApi::Client object (accessed via `.api`)
    # Immediately tests the parameters provided that
    # actually reference a running Jenkins server, and
    # that the user can be authenticated
    def self.connect(config)
      config["username"] ||= ""
      config["password"] ||= ""
      @api = JenkinsApi::Client.new(config)
      @api.api_get_request("")
    end

    def self.api
      @api
    end

    module Helpers
      def api
        JenkinsTestHarness::Api.api
      end
    end
  end
end