include_recipe "python::pip"

node['buildbot']['packages'].each do |pkg|
  package pkg
end

node['buildbot']['pip_packages'].each do |pkg|
  python_pip pkg do
    action :install
  end
end

user "buildbot" do
  comment "Buildbot user"
  system true
  shell "/bin/false"
end

directory node['buildbot']['deplot_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Create master" do
  command "buildbot create-master #{node['buildbot']['master_dir']}"
  cwd node['buildbot']['deplot_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :run
end

execute "Start the master" do
  command "buildbot start master"
  cwd node['buildbot']['deplot_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

master_cfg = ::File.join(node['buildbot']['deplot_to'],
                         node['buildbot']['master_dir'],
                         'master.cfg')
template master_cfg do
  source "master.cfg.erb"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  variables(
    :slave_name => node['buildbot']['slave']['name'],
    :slave_pass => node['buildbot']['slave']['password'],
    :repo => node['buildbot']['repo']['uri'],
    :branch => node['buildbot']['repo']['branch'],
    :workdir => node['buildbot']['repo']['workdir'],
    :auth_user => node['buildbot']['status']['auth_user'],
    :auth_pass => node['buildbot']['status']['auth_pass']
  )
  notifies :run, resources(:execute => "Start the master"), :immediately
end

execute "Start the slave" do
  command "buildslave start slave"
  cwd node['buildbot']['deplot_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

execute "Create slave" do
  command "buildslave create-slave #{node['buildbot']['slave_dir']} localhost:9989 #{node['buildbot']['slave']['name']} #{node['buildbot']['slave']['password']}"
  cwd node['buildbot']['deplot_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  notifies :run, resources(:execute => "Start the slave")
end
