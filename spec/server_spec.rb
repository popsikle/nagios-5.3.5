require 'spec_helper'

describe 'ubuntu_12.04' do
  let(:chef_run) { runner({}, 'prod', 'ubuntu', '12.04').converge 'nagios::server' }
  subject { chef_run }
  before do
    # nagios::server_package stubs
    stub_command('dpkg -l nagios3').and_return(true)
  end
  it { should include_recipe 'nagios::server_package' }
  it { should install_package 'nagios3' }
  it { should enable_service 'nagios3' }
  it { should start_service 'nagios3' }
end

describe 'rhel_6' do
  let(:chef_run) { runner({}, 'prod', 'centos', '6.5').converge 'nagios::server' }
  subject { chef_run }
  before do
    # stub to prevent the php cookbook from failing
    stub_command('which php').and_return(true)
  end
  it { should include_recipe 'nagios::server_source' }
  it { should enable_service 'nagios' }
  it { should start_service 'nagios' }
end
