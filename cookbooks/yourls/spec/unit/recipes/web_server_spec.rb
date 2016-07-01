require 'spec_helper'

describe 'yourls-cookbook::web_server' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['yourls']['path'] = '/etc/apache2/sites-available/yourls'
        node.set['yourls']['url'] = 'https://github.com/YOURLS/YOURLS/archive/1.7.1.tar.gz'
        node.set['apache']['dir'] = '/etc/apache2'

        stub_command("/usr/sbin/apache2 -t").and_return(0)
      end.converge(described_recipe)
    end

    it 'installs php5' do
      expect(chef_run).to include_recipe('php')
      expect(chef_run).to install_package('php5-mysql')
    end

    it 'installs apache with necessary modules' do
      expect(chef_run).to include_recipe('apache2')
      expect(chef_run).to include_recipe('apache2::mod_php5')
      expect(chef_run).to include_recipe('apache2::mod_rewrite')
    end

  end
end

