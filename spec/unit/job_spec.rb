describe JenkinsTestHarness::Job do
  before do
    stub_jenkins
    JenkinsTestHarness::Api.connect(valid_config)
  end
  subject { JenkinsTestHarness::Job.new("Test Job Name") }

  it "builds a job" do
    # expect job to be build
    stub_jenkins_api(:post, "/job/Test%20Job%20Name/build", :status => 302)

    build_job = subject.build
    build_job.should be_instance_of(JenkinsTestHarness::JobBuild)
    build_job.job_name.should == "Test Job Name"
    build_job.job_build_number.should == 1
  end

  it "builds a parameterized job" do
    # expect job to be built with parameters
    stub_jenkins_api(:post, "/job/Test%20Job%20Name/buildWithParameters", :status => 302)
    subject.build({"param1" => "value1"})

    build_job = subject.build("some" => "parameter")
    build_job.should be_instance_of(JenkinsTestHarness::JobBuild)
    build_job.job_name.should == "Test Job Name"
    build_job.job_build_number.should == 1
  end

  it "fails to build a job that doesn't exist" do
    expect {
      JenkinsTestHarness::Job.new("Unknown").build
    }.to raise_error(JenkinsTestHarness::Job::NoJobWithName)
  end
end