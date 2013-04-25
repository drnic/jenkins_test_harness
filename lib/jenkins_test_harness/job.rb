module JenkinsTestHarness
  class Job
    include JenkinsTestHarness::Api::Helpers
    attr_reader :job_name

    class NoJobWithName < StandardError; end
    class JobAlreadyRunning < StandardError; end

    def initialize(job_name, options={})
      @job_name = job_name
      @quiet_period = options[:quiet_period] || 5
    end

    def build(params={})
      validate_job_name
      request_build_else_fail(params)
      wait_for_quiet_period
      JobBuild.new(job_name, current_build_number)
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

    def current_build_number
      api.job.get_current_build_number(job_name)
    end

    def wait_for_quiet_period
      sleep(@quiet_period.to_i + 1)
    end
  end
end