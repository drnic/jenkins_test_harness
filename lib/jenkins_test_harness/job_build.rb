module JenkinsTestHarness
  class JobBuild
    include JenkinsTestHarness::Api::Helpers

    attr_reader :job_name
    attr_reader :job_build_number
    def initialize(job_name, job_build_number)
      @job_name         = job_name
      @job_build_number = job_build_number
    end

    def wait_til_complete
      while status == "running"
        sleep 1
      end
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

    # The text console output from the running/finished build
    def console_output
      console_output, start, more = "", 0, true
      while more
        response = api.job.get_console_output(job_name, job_build_number, start, 'text')
        # @return [Hash] response
        #   * +output+ Console output of the job
        #   * +size+ Size of the text. This can be used as 'start' for the
        #   next call to get progressive output
        #   * +more+ More data available for the job. 'true' if available
        #            and nil otherwise
        more = (response["more"] == "true")
        console_output += response["output"]
        start += response["size"].to_i
      end
      console_output
    end
  end
end
