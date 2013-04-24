describe JenkinsTestHarness::Server do
  subject { JenkinsTestHarness::Server.new }
  it "knows its Jenkins server version" do
    subject.version.should =~ /^1\./
  end
  it "runs jenkins server & stops it"
end