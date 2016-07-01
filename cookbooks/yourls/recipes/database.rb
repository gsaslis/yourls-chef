#
# Cookbook Name:: yourls-cookbook
# Recipe:: database
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

mysql2_chef_gem 'default' do
  client_version node['mysql']['version'] if node['mysql'] && node['mysql']['version']
  action :install
end

mysql_service 'yourls' do
  bind_address '127.0.0.1'
  port '3306'
  version '5.6'
  initial_root_password node['yourls']['mysql_root_pass']
  action [:create, :start]
end

mysql_admin_connection_info = {
  host: '127.0.0.1',
  port: '3306',
  username: 'root',
  password: node['yourls']['mysql_root_pass']
}

# create mysql db
mysql_database 'yourls' do
  connection(
    :host     => '127.0.0.1',
    :username => 'root',
    :password => node['yourls']['mysql_root_pass']
  )
  action :create
end

# Create a mysql user but grant no privileges
# mysql_database_user 'yourls' do
#   connection mysql_admin_connection_info
#   password node['yourls']['mysql_yourls_pass']
#   action :create
# end

# grant privileges on new db
mysql_database_user 'yourls' do
  connection mysql_admin_connection_info
  password node['yourls']['mysql_yourls_pass']
  database_name 'yourls'
  host '%'
  privileges [:select, :update, :insert, :create]
  action [:create, :grant]
end
