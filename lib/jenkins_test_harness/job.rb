module JenkinsTestHarness
  class Job
    include JenkinsTestHarness::Api::Helpers
    attr_reader :job_name

    class NoJobWithName < StandardError; end
    class JobAlreadyRunning < StandardError; end

    def initialize(job_name)
      @job_name = job_name
    end

    def build(params={})
      validate_job_name
      request_build_else_fail(params)
      JobBuild.new(job_name, 1)
    end

    # Search for +job_name+
    def validate_job_name
      unless api.job.list(job_name).first
        raise NoJobWithName, job_name
      end
    end

    def request_build_else_fail(params)
      response = api.job.build(job_name, params)
      unless response.to_i == 302
        raise "Job '#{job_name}' build failed to start"
      end
    rescue JenkinsApi::Exceptions::ApiException => e
      puts e.backtrace
      raise
    end
  end
end