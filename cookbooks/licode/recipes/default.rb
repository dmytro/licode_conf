#
# Cookbook Name:: licode
# Recipe:: default
#
# Copyright 2015, Dmytro Kovalov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

NAME        = node["licode"]["name"]
CONF        = node["licode"]["conf"]
TMPDIR      = "/opt/tmp/"

BASE        = node["licode"]["base"]
SCRIPTS     = node["licode"]["scripts"]

ENVIRONMENT = node["licode"]["environment"]

package %w{ git rabbitmq-server }

#
# NPM fails to install from apt-get when Chris Lea repo in
# installed. Do it only the first install.
#
package "npm" do
  not_if "test -f /etc/apt/sources.list.d/chris-lea-node_js-trusty.list"
end

directory "/opt/tmp" do
  action :create
  recursive true
end

git "#{Chef::Config[:file_cache_path]}/#{NAME}" do
  action :checkout
  destination "/opt/#{ CONF }"
  repository "https://github.com/rohit103/#{CONF}.git"
end

execute "cp -r licode_conf/licode/ /opt/" do
  user "root"
  cwd "/opt"
  not_if "test -d /opt/licode"
end

#
# Make sure that all scripts have execute permissions
#
execute "chmod" do
  command "find /opt -name \\*.sh -o -name configure | xargs chmod +x "
  user "root"
  cwd SCRIPTS
end

%w{  express node-getopt body-parser socket.io amqp mongojs log4js net nuve-server nuve-client fs http https formidable forever fs-extra http-proxy }.map do |pkg|
  execute  "npm install #{pkg}" do
    not_if "npm list #{pkg} | grep #{pkg}"
  end
end

execute "./installUbuntuDepsUnattended.sh" do
  user "root"
  cwd SCRIPTS
  environment ENVIRONMENT
  # not_if "test -d #{BASE}/build/libdeps/opus-1.1"
end

include_recipe "licode::config"

include_recipe "licode::start"
