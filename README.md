# hipsnip-jetty

A cookbook to setup a Jetty 8/9 server.

[![Build status](https://api.travis-ci.org/hipsnip-cookbooks/jetty.png)](https://travis-ci.org/hipsnip-cookbooks/jetty) [![Dependency Status](https://gemnasium.com/hipsnip-cookbooks/jetty.png)](https://gemnasium.com/hipsnip-cookbooks/jetty)

## Requirements

Built to run on Linux distribution. Tested on Ubuntu 12.04.
Depends on the `java` cookbook.

## Usage

By default the Jetty server is running on port 8080, override `node[:jetty][:port]` if you're not happy with that.
As you can see below you can personnalized your Jetty installation thanks to a bunch of attributes to run a Jetty server as you wish.

__N.B:__ Do not freak out when you see this message on the root page of the Jetty server.

	Error 404 - Not Found.

	No context on this server matched or handled this request.
	Contexts known to this server are:

Everything is alright, it only means that nothing is deployed on the root context which is okay that's your job ;).

For example if you like to install Jetty 9 and use syslog:

	node.set['java']['jdk_version'] = 7

	node.set['jetty']['port'] = 8080
	node.set['jetty']['version'] = '9.0.3.v20130506'
	node.set['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/9.0.3.v20130506/dist/jetty-distribution-9.0.3.v20130506.tar.gz&r=1'
	node.set['jetty']['checksum'] = 'eff8c9c63883cae04cec82aca01640411a6f8804971932cd477be2f98f90a6c4'

	node.set['jetty']['syslog']['enable'] = true
	node.set['jetty']['syslog']['priority'] = 'user.notice'
	node.set['jetty']['syslog']['tag'] = 'TEST'

	include_recipe 'hipsnip-jetty'

For more usage examples, have a look to the recipes in test/cookbooks/hipsnip-jetty_test/recipes/.

## Attributes

* `node["jetty"]["user"]` - name of the jetty user, default "jetty".
* `node["jetty"]["group"]` - name of the jetty group, default "jetty".
* `node["jetty"]["home"]` - location of the home directory of jetty, default "/usr/share/jetty".
* `node["jetty"]["port"]` - port number of where jetty listens, default 8080
* `node["jetty"]["args"]` - arguments pass to jetty at startup , default [], e.g: ["jetty.logs=/var/log/jetty"].
* `node["jetty"]["logs"]` - location of the log directory for jetty logs files, default "/var/log/jetty", by default only a file containing the logs of each requests is created by Jetty in this folder, all other logs go to stdout but you use the attributes to put all logs in syslog or separate files.
* `node["jetty"]["java_options"]` - extra arguments pass to the jvm, default []. Note: Between two chef run the attributes are saved on the node if you add on each run an argument, the argument will be duplicated on each new run in the array, use ".uniq" method if you don't want to have duplicated argument in your array when you add a new argument.

* `node["jetty"]["add_confs"]` - set of paths, each path must point to a Jetty configuration file, relative path are relative to jetty home directory, default []. e.g: ['etc/jetty-webapps.xml', 'etc/jetty-http.xml']

* `node["jetty"]["version"]`	- version of jetty, default '8.1.10.v20130312'.
* `node["jetty"]["link"]` - link to the jetty archive, default 'http://eclipse.org/downloads/download.php?file=/jetty/stable-8/dist/jetty-distribution-8.1.10.v20130312.tar.gz&r=1', the link and the version must be coherent.
* `node["jetty"]["checksum"]` - hash sha256 of the jetty archive, default 'e966f87823adc323ce67e99485fea126b84fff5affdc28aa7526e40eb2ec1a5b'
* `node["jetty"]["directory"]` - location of the extracted archive, default "/usr/local/src"

* `node["jetty"]["log"]["level"]`  - log level , default "INFO". levels: SEVERE ERROR WARNING INFO CONFIG FINE FINER FINEST
* `node["jetty"]["log"]["class"]` - java class used for logging, default "org.eclipse.jetty.util.log.StdErrLog"

* `node["jetty"]["syslog"]["enable"]` - if true, it will use the utility logger to log messages into syslog, default false. In order to do this a custom init script is used, see in the "templates" folder, the init script is different for Jetty 8 and Jetty 9.
* `node["jetty"]["syslog"]["priority"]` - string expressing the priority, format expected is "facilility.level", passes the given string as value to the logger utility into the option "--priority"
* `node["jetty"]["syslog"]["tag"]` - tag the messages with the given string, passes the given string as value to the logger utility into the option "--tag"

* `node["jetty"]["start_ini"]["custom"]` - if true, it will generate a configuration file `start.ini` from the value of the node attribute `["jetty"]["start_ini"]["content"]`, it means that the default configuration file `start.ini` downloaded from the mirror will not be copied in the jetty home, default false.
* `node["jetty"]["start_ini"]["content"]` - an array of strings, each row is a line of text in the configuration file `start.ini`. The value of this attribute is used only if `node["jetty"]["start_ini"]["custom"]` = true otherwise the value is ignored. default [].


## Cookbook development

You will need to do a couple of things to be up to speed to hack on this cookbook.
Everything is explained [here](https://github.com/hipsnip-cookbooks/cookbook-development) have a look.

## Test

	bundle exec rake cookbook:full_test


## Licence

Author: Rémy Loubradou

Copyright 2013 HipSnip Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.