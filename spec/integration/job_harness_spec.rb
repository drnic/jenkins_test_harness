# Tests JobHarness against a running Jenkins server
describe JenkinsTestHarness::JobHarness do
  include JenkinsTestHarness::Api::Helpers
  let(:job_name) { "Test Job" }
  before(:all) do
    # run jenkins server
    # wait for it to finish running
    @server = JenkinsTestHarness::Server.new(port: 3333)
    @server.start

    config = {
      "server_ip"   => "localhost",
      "server_port" => "8080",
      "debug"       => "true"
    }
    JenkinsTestHarness::Api.connect(config)

    # upload job to test "Test Job"
  end
  after(:all) do
    # shutdown jenkins server
  end
  it "runs the job & then the job harness" do
    job = JenkinsTestHarness::Job.new(job_name)
    latest_build_number = api.job.get_current_build_number(job_name)
    build_job = job.build
    build_job.job_build_number.should == latest_build_number + 1
    build_job.status.should == "success"
    build_job.job_name.should == job_name

    job_harness = JenkinsTestHarness::JobHarness.new("Test Job")
    clone_job = job_harness.build
    clone_job.job_build_number.should == 1
    build_job.status.should == "success"
    build_job.job_name.should_not == job_name
  end
end