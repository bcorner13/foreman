# -*- coding: utf-8 -*-
#
# Cookbook Name:: foreman
# Recipe:: repo
#

case node['platform_family']
when 'debian'
  include_recipe 'apt'
  apt_repository 'foreman' do
    uri node['foreman']['repo']['uri']
    distribution node['lsb']['codename']
    components node['foreman']['repo']['components']
    key node['foreman']['repo']['key']
  end

  apt_repository 'foreman_plugins' do
    uri node['foreman']['repo']['uri']
    distribution 'plugins'
    components node['foreman']['repo']['components']
    key node['foreman']['repo']['key']
  end

when 'rhel'
  include_recipe 'yum'
  yum_repository 'epel' do
    mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=$basearch'
    description 'Extra Packages for Enterprise Linux 7 - $basearch'
    enabled true
    gpgcheck true
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  end
  case node['platform']
  when 'centos'
    yum_package 'centos-release-scl'
  when 'rhel'
    bash 'enable RHSCL' do
      code 'sudo yum-config-manager --enable rhel-server-rhscl-7-rpms'
    end
  end

  yum_repository 'foreman' do
    description 'Foreman package repo'
    baseurl node['foreman']['yum_repository']['base_url']
    gpgkey node['foreman']['yum_repository']['gpgkey']
  end

  yum_repository 'foreman_plugins' do
    description 'Foreman plugins repo'
    baseurl node['foreman']['yum_repository']['plugin_url']
  end
end
