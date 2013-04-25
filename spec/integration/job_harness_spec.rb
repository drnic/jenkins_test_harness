# Tests JobHarness against a running Jenkins server
describe JenkinsTestHarness::JobHarness do
  include JenkinsTestHarness::Api::Helpers
  let(:job_name) { "Test Job" }

  before do
    JenkinsTestHarness::Api.connect({
      "server_ip"   => "localhost",
      "server_port" => "3333",
      # "debug"       => "true"
    })

    upload_server_job "test_job.xml" # "Test Job"
  end

  it "runs the job & then the job harness" do
    job = JenkinsTestHarness::Job.new(job_name)
    latest_build_number = api.job.get_current_build_number(job_name)
    build_job = job.build("bool_parameter" => "false", "string_parameter" => "Hello")
    build_job.wait_til_complete
    build_job.job_build_number.should == latest_build_number + 1
    build_job.status.should == "success"
    build_job.job_name.should == job_name

    job_harness = JenkinsTestHarness::JobHarness.new("Test Job")
    clone_job = job_harness.build("bool_parameter" => "true", "string_parameter" => "World")
    clone_job.wait_til_complete
    clone_job.job_build_number.should == 1
    clone_job.status.should == "success"
    clone_job.job_name.should_not == job_name
  end
end
