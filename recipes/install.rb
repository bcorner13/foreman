# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: install
#
include_recipe 'foreman::repo' if node['foreman']['use_repo']

package 'foreman' do
  version node['foreman']['version'] unless
    node['foreman']['version'] == 'stable'
end

case node['foreman']['db']['adapter']
when 'sqlite'
  if node['platform_family'] == 'debian'
    pkg = 'foreman-sqlite3'
  else
    pkg = 'foreman-sqlite'
  end
when 'postgresql'
  pkg = 'foreman-postgresql'
when 'mysql'
  pkg = 'foreman-mysql2'
end

package pkg

case node['platform_family']
when 'debian'
  include_recipe 'apache2'
when 'rhel'
  include_recipe 'http'
end


# TODO: remove when apache2 will works fine
#  Recipe: foreman::install
#          * execute[remove-other-vhost] action run
#
#            ================================================================================
#            Error executing action `run` on resource 'execute[remove-other-vhost]'
#            ================================================================================
#
#            Mixlib::ShellOut::ShellCommandFailed
#            ------------------------------------
#            Expected process to exit with [0], but received '1'
#            ---- Begin output of a2disconf other-vhosts-access-log && sleep 2 ----
#            STDOUT:
#            STDERR: ERROR: Conf other-vhosts-access-log does not exist!
#            ---- End output of a2disconf other-vhosts-access-log && sleep 2 ----
#            Ran a2disconf other-vhosts-access-log && sleep 2 returned 1
#
#            Cookbook Trace:
#            ---------------
#            /tmp/kitchen/cache/cookbooks/compat_resource/files/lib/chef_compat/monkeypatches/chef/runner.rb:41:in `run_action'
#
#            Resource Declaration:
#            ---------------------
#            # In /tmp/kitchen/cache/cookbooks/foreman/recipes/install.rb
#
#             30: execute 'remove-other-vhost' do
#             31:   command 'a2disconf other-vhosts-access-log && sleep 2'
#             32: end
#             33:
#
#            Compiled Resource:
#            ------------------
#           # Declared in /tmp/kitchen/cache/cookbooks/foreman/recipes/install.rb:30:in `from_file'
#
#           execute("remove-other-vhost") do
#             action [:run]
#             retries 0
#             retry_delay 2
#             default_guard_interpreter :execute
#             command "a2disconf other-vhosts-access-log && sleep 2"
#             backup 5
#             returns 0
#             declared_type :execute
#             cookbook_name "foreman"
#             recipe_name "install"
#           end
#
#           Platform:
#           ---------
#           x86_64-linux

execute 'remove-other-vhost' do
  command 'a2disconf other-vhosts-access-log && sleep 2'
end

package node['foreman']['passenger']['package'] do
  action :install
  only_if { node['foreman']['passenger']['install'] }
end
