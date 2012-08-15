include_recipe "buildbot::_common"

slave = node['buildbot']['slave']

python_pip "buildbot-slave" do
  action :install
end

directory slave['deploy_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Start the slave" do
  command "buildslave restart slave"
  cwd slave['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

execute "Create slave" do
  command "buildslave create-slave #{slave['options']} #{slave['basedir']} localhost:9989 #{slave['name']} #{slave['password']}"
  cwd slave['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  notifies :run, resources(:execute => "Start the slave")
end

