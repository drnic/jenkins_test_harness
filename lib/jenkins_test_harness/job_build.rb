module JenkinsTestHarness
  class JobBuild
    include JenkinsTestHarness::Api::Helpers

    attr_reader :job_name
    attr_reader :job_build_number
    def initialize(job_name, job_build_number)
      @job_name         = job_name
      @job_build_number = job_build_number
    end

    # Current status of build.
    # Returns one of:
    # * "success"
    # * "failure"
    # * "unstable"
    # * "running"
    # * "not_run"
    # * "aborted"
    # * "invalid"
    def status
      api.job.get_current_build_status(job_name)
    end
  end
end
