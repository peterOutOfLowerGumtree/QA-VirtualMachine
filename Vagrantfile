# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  puts "Hi there"
  config.vm.hostname = "JAMES.qac.local"
  config.vm.box = "chad-thompson/ubuntu-trusty64-gui"

  config.vm.box_check_update = false

  config.vm.network "private_network", ip: "192.168.35.223"

  config.vm.synced_folder "C:\\Users\\Administrator\\VagrantSetup", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    vb.name = "my_vm"
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
  end

  config.vm.provision :shell, path: "bootstrap.sh"
end
