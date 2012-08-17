include_recipe "buildbot::_common"

# Short var name for the node.slave attributes
slave = node['buildbot']['slave']

slave_basedir = ::File.join(slave['deploy_to'], slave['basedir'])

# Install the Python package
python_pip "buildbot-slave" do
  action :install
end


# Deploy the Slave
directory slave['deploy_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Start the slave" do
  command "buildslave restart #{slave_basedir}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

execute "Create slave" do
  command "buildslave create-slave #{slave['options']} #{slave['basedir']} #{node['buildbot']['master']['host']}:9989 #{slave['name']} #{slave['password']}"
  cwd slave['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  notifies :run, resources(:execute => "Start the slave")
end

