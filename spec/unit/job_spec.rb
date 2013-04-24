describe JenkinsTestHarness::Job do
  before do
    stub_jenkins
    JenkinsTestHarness::Api.connect(valid_config)
  end
  subject { JenkinsTestHarness::Job.new("Test Job Name") }

  it "builds a job" do
    # expect test for name being valid
    stub_jenkins_api(:get, "/job/Test%20Job%20Name/api/json", :status => 200)
    # expect job to be build
    stub_jenkins_api(:get, "/job/Test%20Job%20Name/build/api/json", :status => 302)

    build_job = subject.build
    build_job.should be_instance_of(JenkinsTestHarness::JobBuild)
  end

  it "builds a parameterized job" do
    # expect test for name being valid
    stub_jenkins_api(:get, "/job/Test%20Job%20Name/api/json", :status => 200)
    # expect job to be built with parameters
    stub_jenkins_api(:get, "/job/Test%20Job%20Name/buildWithParameters/api/json", :status => 302)
    subject.build({"param1" => "value1"})

    build_job = subject.build
    build_job.should be_instance_of(JenkinsTestHarness::JobBuild)
  end
end