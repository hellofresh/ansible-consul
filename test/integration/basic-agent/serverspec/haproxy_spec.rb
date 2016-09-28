require_relative '../../helper_spec.rb'


describe 'HAPROXY' do

    describe service('haproxy') do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/etc/haproxy/haproxy.cfg') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'consul' }
      it { should be_grouped_into 'consul' }
    end

    describe file('/etc/haproxy/') do
      it { should  be_directory}
      it { should be_mode 775 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'consul' }
    end

    describe "stats page" do
        describe port(3212) do
            it { should be_listening.with('tcp') }
        end

        describe command "curl -s http://127.0.0.1:3212" do
            its(:exit_status) { should eq 0 }
            its(:stdout) { should contain 'Statistics Report' }
        end
    end
end