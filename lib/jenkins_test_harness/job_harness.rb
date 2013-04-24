module JenkinsTestHarness
  class JobHarness
    include JenkinsTestHarness::Api::Helpers
    attr_reader :job_name
    attr_reader :options

    def initialize(job_name, options={})
      @job_name = job_name
      @options = options
      @target_job = Job.new(job_name, options)
    end

    def build(params={})
      @clone_job ||= create_temporary_job_clone
      @clone_job.build(params)
    end

    def create_temporary_job_clone
      temporary_job_name = create_temporary_job_name
      job_xml = api.job.get_config(job_name)
      api.job.create(temporary_job_name, job_xml)
      Job.new(temporary_job_name, options)
    rescue JenkinsApi::Exceptions::ApiException => e
      puts e.backtrace
      raise
    end

    def create_temporary_job_name
      "#{job_name} - Clone"
    end
  end
end