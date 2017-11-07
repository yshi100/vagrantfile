# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu-16.04-rails-dev"

  config.vm.box_check_update = false

  config.ssh.username = "ubuntu"


  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.network "private_network", ip: "192.168.255.10"

  config.vm.synced_folder '.', '/vagrant/jobs.ruby.tw', type: 'nfs'
  config.vm.synced_folder 'd://workspace//skyway', '/vagrant/skyway', type: 'nfs'
  # config.bindfs.bind_folder '/vagrant-nfs/skyway', '/var/www/skyway'


  config.vm.provider 'virtualbox' do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
end
