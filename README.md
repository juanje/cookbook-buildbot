Description
===========

Install a master and slave Buildbot with the default configuration


NOTE
----

Right now, this cookbook is functional and will create a _master_ and _slave_
with the same configuration the Official Guide provides.

It's also highly configurable through attributes.

But this need some work to make it more flexible and suit more case scenarios.


Requirements
============

Cookbooks
---------

* python

Platform
--------

* Debian/Ubuntu
* RHEL/CentOS


Usage
=====

You can create a Buildbox box just adding the default recipe to the node's _runlist_.

But you also can create separate boxes, master and slaves, by adding just the recipe `master`
or the recipe `slave`.


NOTE
----

Some _Vagrant_ and _role_ examples will be provide soon. Those examples will show
how to change almost anything with attributes.


License and Author
==================

Author:: Juanje Ojeda <juanje.ojeda@gmail.com>

Copyright:: 2012 Juanje Ojeda <juanje.ojeda@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

