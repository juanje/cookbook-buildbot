include_recipe "python::pip"

# Master

master = node['buildbot']['master']

master['packages'].each do |pkg|
  package pkg
end

master['pip_packages'].each do |pkg|
  python_pip pkg do
    action :install
  end
end

user "buildbot" do
  comment "Buildbot user"
  system true
  shell "/bin/false"
end

directory master['deploy_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Create master" do
  command "buildbot create-master #{master['options']} #{master['basedir']}"
  cwd master['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :run
end

execute "Start the master" do
  command "buildbot start master"
  cwd master['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

force_build_attrib = node['buildbot']['status']['force_build']
force_build = case force_build_attrib
              when /^[Tt]rue$/, /^[Ff]alse$/
                force_build_attrib.capitalize
              else
                %{'#{force_build_attrib}'}
              end

template master['cfg'] do
  source "master.cfg.erb"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  variables(
    :slaves      => node['buildbot']['slaves'],
    :repo        => node['buildbot']['repo']['uri'],
    :branch      => node['buildbot']['repo']['branch'],
    :workdir     => node['buildbot']['repo']['workdir'],
    :force_build => force_build,
    :auth_user   => node['buildbot']['status']['auth_user'],
    :auth_pass   => node['buildbot']['status']['auth_pass']
  )
  notifies :run, resources(:execute => "Start the master"), :immediately
end


# Slave

slave = node['buildbot']['slave']

slave['packages'].each do |pkg|
  package pkg
end

slave['pip_packages'].each do |pkg|
  python_pip pkg do
    action :install
  end
end

directory master['deploy_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Start the slave" do
  command "buildslave start slave"
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
