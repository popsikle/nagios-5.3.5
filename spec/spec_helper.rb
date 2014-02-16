require 'chefspec'
require 'chefspec/berkshelf'

def runner(attributes = {}, environment = 'test', platform, platform_version)
  # A workaround so that ChefSpec can work with Chef environments (from https://github.com/acrmp/chefspec/issues/54)
  @runner ||= ChefSpec::Runner.new(:platform => platform, :version => platform_version) do |node|
    env = Chef::Environment.new
    env.name environment
    node.stub(:chef_environment).and_return env.name
    Chef::Environment.stub(:load).and_return env

    Chef::DataBag.stub(:list).and_return([])

    stub_search(:users, 'groups:sysadmin NOT action:remove').and_return([])

    stub_search(:node, 'name:* AND chef_environment:prod').and_return([])

    stub_search(:role, '*:*').and_return([])

    attributes.each_pair do |key, val|
      node.set[key] = val
    end
  end
end
