include_recipe "buildbot::_common"

master_basedir = ::File.join(node['buildbot']['master']['deploy_to'],
                             node['buildbot']['master']['basedir'])
master_cfg = ::File.join(master_basedir, node['buildbot']['master']['cfg'])
options = node['buildbot']['master']['options']


# Install the Python package
python_pip "buildbot" do
  action :install
end


# Deploy the Master
directory node['buildbot']['master']['deploy_to'] do
  recursive true
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Create master" do
  command "buildbot create-master #{options} #{master_basedir}"
  cwd node['buildbot']['master']['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :run
end

execute "Start the master" do
  command "buildbot restart #{master_basedir}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

template master_cfg do
  source "master.cfg.erb"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  variables(
    :host          => node['buildbot']['master']['host'],
    :databases     => node['buildbot']['master']['databases'],
    :slave_port    => node['buildbot']['slave']['port'],
    :title         => node['buildbot']['project']['title'],
    :title_url     => node['buildbot']['project']['title_url'],
    :imports       => node['buildbot']['imports'],
    :change_source => node['buildbot']['change_source'],
    :slaves        => node['buildbot']['slaves'],
    :builders      => node['buildbot']['builders'],
    :steps         => node['buildbot']['steps'],
    :schedulers    => node['buildbot']['schedulers'],
    :statuses      => node['buildbot']['status']
  )
  notifies :run, resources(:execute => "Start the master"), :immediately
end

