# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'rails-vagrant-box'  # 18.04
  config.vm.hostname = 'rails-vagrant-box'
  config.disksize.size = '20GB'

  config.ssh.insert_key = false
  #config.ssh.forward_agent = true
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.network "private_network", ip: "192.168.255.10"

  config.vm.synced_folder '.', '/vagrant' #, type: "rsync", rsync_auto: true 

  config.vm.provider 'virtualbox' do |v|
    v.memory = ENV.fetch('RAILS_DEV_BOX_RAM', 4096).to_i
    v.cpus   = ENV.fetch('RAILS_DEV_BOX_CPUS', 2).to_i

    # v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]

    v.customize [ "modifyvm", :id, "--uart1", "0x3F8", "4" ]
    v.customize [ "modifyvm", :id, "--uartmode1", "file", File.join(Dir.pwd, "ubuntu-bionic-18.04-cloudimg-console.log") ]

    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
end
