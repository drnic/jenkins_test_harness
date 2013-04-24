module JenkinsTestHarness
  class Job
    attr_reader :job_name

    def initialize(job_name)
      @job_name = job_name
    end

    def build(parameters={})
      JobBuild.new(job_name, 1)
    end
  end
end