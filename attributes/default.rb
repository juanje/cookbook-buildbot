default['buildbot']['user'] = 'buildbot'
default['buildbot']['group'] = 'buildbot'

default['buildbot']['master']['deploy_to'] = '/opt/buildbot'
default['buildbot']['master']['basedir'] = 'master'
default['buildbot']['master']['options'] = ''
default['buildbot']['master']['cfg'] = 'master.cfg'


default['buildbot']['slave']['deploy_to'] = '/opt/buildbot'
default['buildbot']['slave']['options'] = ''
default['buildbot']['slave']['name'] = 'example-slave'
default['buildbot']['slave']['password'] = 'pass'
default['buildbot']['slave']['basedir'] = 'slave'

# Info for the master. This is for the case when it is deployed with chef-solo
# One Master and one Slave.
# For Chef Server it should be discovered by searching
default['buildbot']['slaves'] = [{
  :name     => node['buildbot']['slave']['name'],
  :password => node['buildbot']['slave']['password'],
  :basedir  => node['buildbot']['slave']['basedir']
}]

default['buildbot']['project']['title'] = 'Pyflakes'
default['buildbot']['project']['title_url'] = 'http://divmod.org/trac/wiki/DivmodPyflakes'
default['buildbot']['project']['repo'] = 'git://github.com/buildbot/pyflakes.git'
default['buildbot']['project']['branch'] = 'master'
default['buildbot']['project']['workdir'] = 'gitpoller-workdir'

default['buildbot']['status']['force_build'] = 'True' # 'False' or 'auth'
default['buildbot']['status']['auth_user'] = 'pyflakes'
default['buildbot']['status']['auth_pass'] = 'pyflakes'

default['buildbot']['steps'] = [
  %{Git(repourl='#{node['buildbot']['project']['repo']}', mode='copy')},
  %{ShellCommand(command=["trial", "pyflakes"])}
  ]
