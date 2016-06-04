require 'spec_helper'

describe 'superssh service (localport option)' do
    describe command "curl -s http://127.0.0.1:8500/v1/catalog/service/superssh -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"ServiceName":"superssh"' }
        its(:stdout) { should contain '"ServiceTags":\["test"]' }
        its(:stdout) { should contain '"ServicePort":22' }
    end

    describe "localport 2222 is open" do
      describe port(2222) do
        it { should be_listening.on('127.0.0.1').with('tcp') }
      end
    end

    describe "ssh is working on 2222" do
      describe command "ssh-keyscan -p 2222 localhost" do 
        its(:exit_status) { should eq 0 }
        its(:stderr) { should contain '# localhost SSH-2.0-OpenSSH' }
      end
    end
end


describe 'google service (normal port option)' do
    describe command "curl -s http://127.0.0.1:8500/v1/catalog/service/google -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"ServiceName":"google"' }
        its(:stdout) { should contain '"ServiceAddress":"www.google.com"' }
        its(:stdout) { should contain '"ServicePort":80' }
    end

    describe "localport 80 is open" do
      describe port(80) do
        it { should be_listening.on('127.0.0.1').with('tcp') }
      end
    end

    describe "google is working on 80" do
      describe command "curl -I -s http://www.google.com" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain 'HTTP/1.1 302 Found' }
      end
    end
end


#describe 'superdb service' do

#end