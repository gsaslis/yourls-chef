require 'spec_helper'

describe 'yourls-cookbook::database' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['yourls']['path'] = '/etc/apache2/sites-available/yourls'
        node.set['yourls']['url'] = 'https://github.com/YOURLS/YOURLS/archive/1.7.1.tar.gz'

      end.converge(described_recipe)
    end

    it 'installs mysql service' do
      expect(chef_run).to create_mysql_service('yourls')
      expect(chef_run).to start_mysql_service('yourls')
    end

    it 'creates a yourls database, if not already set up' do
      expect(chef_run).to create_mysql_database('yourls').with(      )
    end

    it 'creates a database user for yourls' do
      expect(chef_run).to create_mysql_database_user('yourls')
    end

    it 'grants database user select, update, insert privileges' do
      expect(chef_run).to grant_mysql_database_user('yourls').with(
        privileges: [:select, :update, :insert, :create],
        database_name: 'yourls',
        host: '%'
      )
    end

  end
end
