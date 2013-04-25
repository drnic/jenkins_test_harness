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
      wait_for_quiet_period
      JobBuild.new(job_name, current_build_number)
    end

    # (re-)create the +Job+ using the config.xml located at +config_path+
    # If Job already exists, it is deleted; before being created again
    def upload(config_path)
      config = File.read(config_path)
      destroy
      api.job.create(job_name, config)
    end

    # If job exists, delete it from Jenkins and return true
    # Else return false
    def destroy
       if job_exists?
         api.job.delete(job_name)
         true
       end
    end

    # returns true if this +job_name+ exists in Jenkins server
    def job_exists?
      api.job.list(job_name).first
    end

    # Search for +job_name+
    def validate_job_name
      unless job_exists?
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

    def quiet_period
      Api.quiet_period
    end

    def wait_for_quiet_period
      sleep(quiet_period.to_i + 1)
    end
  end
end