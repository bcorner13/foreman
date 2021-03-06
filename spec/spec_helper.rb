# -*- coding: utf-8 -*-
#
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'

ChefSpec::Coverage.start! { add_filter 'foreman' }

require 'chef/application'

UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '14.04',
  log_level: :fatal
}

RSpec.configure do |config|
  config.path = 'spec/ohai.json'
end

shared_context 'foreman_stubs' do
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
    stub_command('ls /var/lib/postgresql/9.3/main/recovery.conf')
      .and_return(true)
    stub_command('ls /var/lib/pgsql/data/recovery.conf').and_return(true)
  end
end
