default['buildbot']['user'] = 'buildbot'
default['buildbot']['group'] = 'buildbot'

default['buildbot']['project']['title'] = 'Pyflakes'
default['buildbot']['project']['title_url'] = 'http://divmod.org/trac/wiki/DivmodPyflakes'

default['buildbot']['master']['host'] = 'localhost'
default['buildbot']['master']['deploy_to'] = '/opt/buildbot'
default['buildbot']['master']['basedir'] = 'master'
default['buildbot']['master']['options'] = ''
default['buildbot']['master']['cfg'] = 'master.cfg'
default['buildbot']['master']['databases'] = [ 'sqlite:///state.sqlite' ]

default['buildbot']['slave']['port'] = '9989'
default['buildbot']['slave']['deploy_to'] = '/opt/buildbot'
default['buildbot']['slave']['options'] = ''
default['buildbot']['slave']['name'] = 'example-slave'
default['buildbot']['slave']['password'] = 'pass'
default['buildbot']['slave']['basedir'] = 'slave'

# Info for the master. This is for the case when it is deployed with chef-solo
# One Master and one Slave.
# For Chef Server it should be discovered by searching
default['buildbot']['slaves'] = [{
  'name'     => node['buildbot']['slave']['name'],
  'password' => node['buildbot']['slave']['password'],
  'basedir'  => node['buildbot']['slave']['basedir']
}]

# Change Source
default['buildbot']['imports']['change_source'] = [
  'from buildbot.changes.gitpoller import GitPoller'
]
default['buildbot']['change_source'] = "GitPoller(
    repourl='git://github.com/buildbot/pyflakes.git',
    workdir='gitpoller-workdir', branch='master',
    pollinterval=300)"

# Builders
default['buildbot']['imports']['factory'] = [
  'from buildbot.process.factory import BuildFactory',
  'from buildbot.config import BuilderConfig'
]
default['buildbot']['builders'] = [
  "BuilderConfig(name='runtests',
    slavenames=[#{node['buildbot']['slaves'].map {|s| "'#{s['name']}'" }.join(',')}],
    factory=factory)"
]

# Steps
default['buildbot']['imports']['steps'] = [
  'from buildbot.steps.source import Git',
  'from buildbot.steps.shell import ShellCommand',
]
default['buildbot']['steps'] = [
  "Git(repourl='git://github.com/buildbot/pyflakes.git', mode='copy')",
  "ShellCommand(command=['trial', 'pyflakes'])"
]

# Schedulers
default['buildbot']['imports']['schedulers'] = [
  'from buildbot.schedulers.basic import SingleBranchScheduler',
  'from buildbot.schedulers.forcesched import ForceScheduler',
  'from buildbot.changes import filter'
]
default['buildbot']['schedulers'] = [
  "SingleBranchScheduler(
    name='all',
    change_filter=filter.ChangeFilter(branch='master'),
    treeStableTimer=None,
    builderNames=['runtests'])",
  "ForceScheduler(
    name='force',
    builderNames=['runtests'])"
]

# Status
default['buildbot']['imports']['status'] = [
'from buildbot.status import html',
'from buildbot.status.web import authz, auth'
]
default['buildbot']['status_authz'] = "authz.Authz(
        auth=auth.BasicAuth([('pyflakes','pyflakes')]),
        gracefulShutdown=False,
        forceBuild='auth',
        forceAllBuilds=False,
        pingBuilder=False,
        stopBuild=False,
        stopAllBuilds=False,
        cancelPendingBuild=False)
"
default['buildbot']['status'] = [
  "html.WebStatus(http_port=8010,
    authz=#{node['buildbot']['status_authz']})"
]

