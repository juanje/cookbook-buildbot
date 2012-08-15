include_recipe "buildbot::_common"

master = node['buildbot']['master']

master['packages'].each do |pkg|
  package pkg
end

master['pip_packages'].each do |pkg|
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

execute "Create master" do
  command "buildbot create-master #{master['options']} #{master['basedir']}"
  cwd master['deploy_to']
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :run
end

execute "Start the master" do
  command "buildbot restart master"
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
    :title       => node['buildbot']['project']['title'],
    :title_url   => node['buildbot']['project']['title_url'],
    :repo        => node['buildbot']['project']['repo'],
    :branch      => node['buildbot']['project']['branch'],
    :workdir     => node['buildbot']['project']['workdir'],
    :steps       => node['buildbot']['steps'],
    :force_build => force_build,
    :auth_user   => node['buildbot']['status']['auth_user'],
    :auth_pass   => node['buildbot']['status']['auth_pass']
  )
  notifies :run, resources(:execute => "Start the master"), :immediately
end


