require 'spec_helper'

describe 'superssh service (localport option)' do
  describe "definition" do 
    describe command "curl -s http://127.0.0.1:8500/v1/catalog/service/superssh -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"ServiceName":"superssh"' }
        its(:stdout) { should contain '"ServiceTags":\["test"]' }
        its(:stdout) { should contain '"ServicePort":22' }
    end
  end

  describe "health is passing" do
    describe command "curl -s http://127.0.0.1:8500/v1/health/service/superssh -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"Name":"Service \'superssh\' check","Status":"passing"' }
    end
  end

  describe "localport 2222 is open by haproxy" do
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
  describe "definition" do 
    describe command "curl -s http://127.0.0.1:8500/v1/catalog/service/google -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"ServiceName":"google"' }
        its(:stdout) { should contain '"ServiceAddress":"www.google.com"' }
        its(:stdout) { should contain '"ServicePort":80' }
    end
  end

  describe "health is passing" do
    describe command "curl -s http://127.0.0.1:8500/v1/health/service/google -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"Name":"Service \'google\' check","Status":"passing"' }
    end
  end

  describe "localport 80 is open by haproxy" do
    describe port(80) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end

  describe "curling to google is working on 80" do
    describe command "curl -I -s http://www.google.com" do 
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain 'HTTP/1.1 302 Found' }
    end
  end
end


describe 'superdb service (A failing service)' do
  describe "definition" do
    describe command "curl -s http://127.0.0.1:8500/v1/catalog/service/superdb -v" do 
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain '"ServiceName":"superdb"' }
      its(:stdout) { should contain '"ServiceTags":\["userdb","v1.2"]' }
      its(:stdout) { should contain '"ServicePort":2122' }
    end
  end

  describe "health is failing" do
    describe command "curl -s http://127.0.0.1:8500/v1/health/service/superdb -v" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain '"Name":"Service \'superdb\' check","Status":"warning"' }
    end
  end

  describe "localport 2122 is open by haproxy" do
    describe port(2122) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end

end


describe 'superapp service (a non advertised service)' do

  describe "definition should not exist" do
    describe command "curl -s http://127.0.0.1:8500/v1/catalog/service/superapp -v" do 
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match '[]' }
    end
  end

  describe "localport 9999 is open by haproxy" do
    describe port(9999) do
      it { should be_listening.on('127.0.0.1').with('tcp') }
    end
  end

end  
