default['buildbot']['packages'] = %w{ git python-dev }
default['buildbot']['pip_packages'] = %w{ buildbot buildbot-slave }

default['buildbot']['user'] = 'buildbot'
default['buildbot']['group'] = 'buildbot'

default['buildbot']['deplot_to'] = '/opt/buildbot'
default['buildbot']['master_dir'] = 'master'
default['buildbot']['slave_dir'] = 'slave'

default['buildbot']['slave']['name'] = 'example-slave'
default['buildbot']['slave']['password'] = 'pass'

default['buildbot']['repo']['uri'] = 'git://github.com/buildbot/pyflakes.git'
default['buildbot']['repo']['branch'] = 'master'
default['buildbot']['repo']['workdir'] = 'gitpoller-workdir'

default['buildbot']['status']['auth_user'] = 'pyflakes'
default['buildbot']['status']['auth_pass'] = 'pyflakes'
