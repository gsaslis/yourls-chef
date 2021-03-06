#
# Cookbook Name:: yourls-cookbook
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Yorgos Saslis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


# Download and extract yourls source
ark 'yourls' do
  url node['yourls']['url']
  path node['yourls']['path']
  owner node['apache']['user']
  action :put
  not_if { ::File.exists?("#{node['yourls']['path']}/yourls") }
end

template "#{node['yourls']['path']}/yourls/user/config.php" do
  source 'yourls_config.php.erb'
  variables({
    :db_pass => node['yourls']['mysql_yourls_pass'],
    :yourls_url => 'default-ubuntu-1404:8880',
    :usernames_passwords => {
      :yourls => :a_random_pass
    }
  })
  owner node['apache']['user']
  group node['apache']['group']
end

file "#{node['yourls']['path']}/yourls/.htaccess" do
  content 'FallBackResource yourls-loader.php'
  mode '0755'
  owner node['apache']['user']
  group node['apache']['group']
end

web_app 'yourls' do
  server_name node['hostname']
  server_aliases [ node['fqdn'] ]
  server_port 8880
  docroot "#{node['yourls']['path']}/yourls"
  allow_override 'All'
  # template 'web_app.conf.erb'
  # cookbook 'yourls-cookbook'
  cookbook 'apache2'
  notifies :restart, 'service[apache2]'
end