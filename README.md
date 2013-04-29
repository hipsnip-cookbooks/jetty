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

## Attributes

* `node["jetty"]["user"]` - name of the jetty user, default "jetty".
* `node["jetty"]["group"]` - name of the jetty group, default "jetty".
* `node["jetty"]["home"]` - location of the home directory of jetty, default "/usr/share/jetty".
* `node["jetty"]["port"]` - port number of where jetty listens, default 8080
* `node["jetty"]["args"]` - arguments pass to jetty at startup , default "", e.g: "jetty.logs=/var/log/jetty".
* `node["jetty"]["logs"]` - location of the log directory for jetty logs files, default "", i.e log into stdout/stderr
* `node["jetty"]["java_options"]` - extra arguments pass to the jvm, default "".

* `node["jetty"]["add_confs"]` - set of paths, each path must point to a Jetty configuration file, relative path are relative to jetty home directory, default []. e.g: ['etc/jetty-webapps.xml', 'etc/jetty-http.xml']

* `node["jetty"]["version"]`	- version of jetty, default "9.0.2.v20130417".
* `node["jetty"]["link"]` - link to the jetty archive, default "http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.2.v20130417.tar.gz&r=1", the link and the version must be coherent.
* `node["jetty"]["checksum"]` - hash sha256 of the jetty archive, default "6ab0c0ba4ff98bfc7399a82a96a047fcd2161ae46622e36a3552ecf10b9cddb9"
* `node["jetty"]["directory"]` - location of the extracted archive, default "/usr/local/src"

* `node["jetty"]["log"]["level"]`  - log level , default "INFO". levels: SEVERE ERROR WARNING INFO CONFIG FINE FINER FINEST
* `node["jetty"]["log"]["class"]` - java class used for logging, default "org.eclipse.jetty.util.log.StdErrLog"

* `node["jetty"]["syslog"]["enable"]` - if true, it will use the utility logger to log messages into syslog, default false. In order to do this a custom init script is used, see in the "templates" folder, the init script is different for Jetty 8 and Jetty 9.
* `node["jetty"]["syslog"]["priority"]` - string expressing the priority, format expected is "facilility.level", passes the given string as value to the logger utility into the option "--priority"
* `node["jetty"]["syslog"]["tag"]` - tag the messages with the given string, passes the given string as value to the logger utility into the option "--tag"


## Cookbook development

You will need to do a couple of things to be up to speed to hack on this cookbook.
Everything is explained [here](https://github.com/hipsnip-cookbooks/cookbook-development) have a look.

## Test

```
bundle exec rake cookbook:full_test
```

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