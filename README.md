# Jenkins::TestHarness

A library to use to run integration tests on Jenkins jobs to ensure they are behaving as expected. Also allows TDD (test-driven development) to be used for the authoring of Jenkins jobs.

## Usage

An example integration test might look like the sample below. You can use any Ruby testing library; or use the `JobTestHarness` class directly outside of a test suite.

In this example, it will invoke/build a parameterized job named "Deploy app to Cloud Foundry" with a hash of parameters (`subject.build(params)`). It then blocks and waits until that job has completed running (`build_job.wait_til_complete`). Finally, it performs assertions. In this example, it is querying the target Cloud Foundry account that there was 1 application deployed with a name "deploy-app-testname" and that there is 1 instance running.

``` ruby
describe "Jenkins job: Deploy app to Cloud Foundry" do
  before(:all) do
    JenkinsTestHarness::Api.connect({
      "server_ip" => ENV['jenkins_server_ip'],
      "server_port" => ENV['jenkins_server_port'],
      "username" => ENV['jenkins_username'],
      "password" => ENV['jenkins_password'],
      "quiet_period" => ENV['jenkins_quiet_period'] || 5,
      "debug" => (ENV['jenkins_api_debug'] == "true")
    })
  end
  let(:job_name) { "Deploy app to Cloud Foundry" }
  subject { JenkinsTestHarness::JobHarness.new(job_name) }

  let(:cf_env) { CloudFoundry.config.cf_env }
  let(:cf_api) { CloudFoundry.client_api }

  before { CloudFoundry.delete_apps(/^deploy-app-testname/) }
  after { subject.cleanup }

  it "deploys app with one 1 instance" do
    build_job = subject.build(valid_job_parameters)
    build_job.wait_til_complete
    app = cf_api.apps.find { |app| app.name == "deploy-app-testname" }
    app.should_not be_nil

    public_url = "deploy-app-testname.#{cf_env}"
    app.uris.should be_include(public_url)

    app.instances.size.should == 1
  end
end
```

The core class `JenkinsTestHarness::JobHarness` uses the Jenkins API to:

1. clone the target job with a random name (`JenkinsTestHarness::JobHarness#build`)
2. trigger the cloned job to be built using the parameters provided (which become environment variables when the job is running).
3. cloned job is destroyed (`JenkinsTestHarness::JobHarness#cleanup`)

This means that the target job ("Deploy app to Cloud Foundry" in the example) itself is not run; rather a temporary clone of the Job is run.

There is also a class `JenkinsTestHarness::Job` which performs only step 2 above - it triggers a job to be run (`JenkinsTestHarness::Job#build`).

## Installation

Add this line to your application's Gemfile:

    gem 'jenkins-test-harness'

And then execute:

    $ bundle

## Development

The `spec` folder contains the unit and integration tests for the library classes. The integration tests actually use a running Jenkins server, import a job to test, and run examples of `JenkinsTestHarness::JobHarness#build` upon that test job.

To run all the tests use:

```
$ rake
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
