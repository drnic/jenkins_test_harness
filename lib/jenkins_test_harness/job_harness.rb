module JenkinsTestHarness
  class JobHarness
    attr_reader :job_name

    def initialize(job_name)
      @job_name = job_name
    end

    def build(parameters={})
      
    end
  end
end