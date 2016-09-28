require_relative '../../helper_spec.rb'

describe 'consul UI' do
    ui_port = 8500

    describe port(ui_port) do
      it { should be_listening }
    end

    describe command "curl -s  http://127.0.0.1:#{ui_port}/ui/ | grep '<title>'" do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should contain "<title>Consul by HashiCorp</title>" }
    end

end
