describe JenkinsTestHarness::JobHarness do
  before do
    stub_jenkins
    stub_jenkins_jobs(["Test Job Name", "Test Job Name - Clone"])
    JenkinsTestHarness::Api.connect(valid_config)

    # expect target job's config to be downloaded
    stub_jenkins_api(:get, "/job/Test%20Job%20Name/config.xml", body: "<job>config</job>")

    # expect cloned job to be created using target job's config
    stub_jenkins_api(:post, "/createItem?name=Test%20Job%20Name%20-%20Clone", :status => 302)
  end
  subject { JenkinsTestHarness::JobHarness.new("Test Job Name") }

  it "runs a job: creates clone, builds it, destroys it" do
    # expect cloned job to be built; not target job
    stub_jenkins_api(:post, "/job/Test%20Job%20Name%20-%20Clone/build", :status => 302)

    job_build = subject.build
    job_build.should be_instance_of(JenkinsTestHarness::JobBuild)
    job_build.job_name.should == "Test Job Name - Clone"
    job_build.job_build_number.should == 11
  end

  it "runs a parameterized job: creates clone, builds it, destroys it" do
    # expect cloned job to be built; not target job
    stub_jenkins_api(:post, "/job/Test%20Job%20Name%20-%20Clone/buildWithParameters", :status => 302)

    job_build = subject.build({"param1" => "value1"})
    job_build.should be_instance_of(JenkinsTestHarness::JobBuild)
    job_build.job_name.should == "Test Job Name - Clone"
    job_build.job_build_number.should == 11
  end
end