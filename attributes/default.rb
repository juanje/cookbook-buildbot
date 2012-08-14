default['buildbot']['user'] = 'buildbot'
default['buildbot']['group'] = 'buildbot'

default['buildbot']['master']['packages'] = case platform
                                            when 'debian', 'ubuntu'
                                                %w{ git-core python-dev }
                                            else
                                                %w{ git python-dev }
                                            end
default['buildbot']['master']['pip_packages'] = %w{ buildbot }
default['buildbot']['master']['deploy_to'] = '/opt/buildbot'
default['buildbot']['master']['basedir'] = 'master'
default['buildbot']['master']['options'] = ''
default['buildbot']['master']['cfg'] = ::File.join(
  node['buildbot']['master']['deploy_to'],
  node['buildbot']['master']['basedir'],
  'master.cfg')


default['buildbot']['slave']['packages'] = case platform
                                           when 'debian', 'ubuntu'
                                               %w{ git-core python-dev }
                                           else
                                               %w{ git python-dev }
                                           end
default['buildbot']['slave']['pip_packages'] = %w{ buildbot-slave }
default['buildbot']['slave']['deploy_to'] = '/opt/buildbot'
default['buildbot']['slave']['options'] = ''
default['buildbot']['slaves'] = [{
  :name     => 'example-slave',
  :password => 'pass',
  :basedir  => 'slave'
}]
default['buildbot']['slave']['name'] = 'example-slave'
default['buildbot']['slave']['password'] = 'pass'
default['buildbot']['slave']['basedir'] = 'slave'

default['buildbot']['repo']['uri'] = 'git://github.com/buildbot/pyflakes.git'
default['buildbot']['repo']['branch'] = 'master'
default['buildbot']['repo']['workdir'] = 'gitpoller-workdir'

default['buildbot']['status']['force_build'] = 'True' # 'False' or 'auth'
default['buildbot']['status']['auth_user'] = 'pyflakes'
default['buildbot']['status']['auth_pass'] = 'pyflakes'
