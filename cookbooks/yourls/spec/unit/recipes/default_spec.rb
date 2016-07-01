#
# Cookbook Name:: yourls-cookbook
# Spec:: default
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


require 'spec_helper'

describe 'yourls-cookbook::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['yourls']['path'] = '/etc/apache2/sites-available/yourls'
        node.set['yourls']['url'] = 'https://github.com/YOURLS/YOURLS/archive/1.7.1.tar.gz'
        node.set['apache']['dir'] = '/etc/apache2'

        stub_command("/usr/sbin/apache2 -t").and_return(0)
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'downloads yourls from source' do
      expect(chef_run).to put_ark('yourls').with(
        url: 'https://github.com/YOURLS/YOURLS/archive/1.7.1.tar.gz',
        path: '/etc/apache2/sites-available/yourls'
      )
    end

    # it 'installs yourls in apache' do
      # TODO
    # end

    it 'installs yourls plugins' do
      # TODO
    end

    it 'modifies the default yourls config file' do
      # TODO
    end

  end
end
