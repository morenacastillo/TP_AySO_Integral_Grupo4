# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "VM1-Grupo4" do |vmHost1|
    vmHost1.vm.box = "ubuntu/jammy64"
    vmHost1.vm.hostname = "vmHost1"
    vmHost1.vm.network "private_network", :name => '', ip: "192.168.56.4"
    
    # Comparto la carpeta del host donde estoy parado contra la vm
    vmHost1.vm.synced_folder 'compartido_Host1/', '/home/vagrant/compartido', 
    owner: 'vagrant', group: 'vagrant' 

      # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
      vmHost1.ssh.insert_key = true
      # Agrego un nuevo disco 
      vmHost1.vm.disk :disk, size: "5GB", name: "#{vmHost1.vm.hostname}_extra_storage1"
      vmHost1.vm.disk :disk, size: "3GB", name: "#{vmHost1.vm.hostname}_exxtra_storage2"
      vmHost1.vm.disk :disk, size: "2GB", name: "#{vmHost1.vm.hostname}_exxtra_storage3"
      vmHost1.vm.disk :disk, size: "1GB", name: "#{vmHost1.vm.hostname}_extra_storage4"

      vmHost1.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.name = "vmHost1"
        vb.cpus = 1
        vb.linked_clone = true
        # Seteo controladora Grafica
        vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']      
      end    
      # Puedo Ejecutar un script que esta en un archivo
      vmHost1.vm.provision "shell", path: "script_Enable_ssh_password.sh"
      vmHost1.vm.provision "shell", path: "instala_paquetes.sh"
      vmHost1.vm.provision "shell", privileged: false, inline: <<-SHELL
      # Los comandos aca se ejecutan como vagrant
	dnf install sshpass -y
  	dnf install -y /home/vagrant/compartido/tree-1.8.0-10.el9.x86_64.rpm
      mkdir -p /home/vagrant/repogit
      cd /home/vagrant/repogit
      git clone https://github.com/upszot/UTN-FRA_SO_onBording.git 
      git clone https://github.com/upszot/UTN-FRA_SO_Ansible.git
      git clone https://github.com/upszot/UTN-FRA_SO_Docker.git

    SHELL
    end
    
    
    config.vm.define "VM2-Grupo4" do |vmHost2|
      vmHost2.vm.box = "fedora/38-cloud-base"
      vmHost2.vm.hostname = "vmHost2"
      vmHost2.vm.network "private_network", :name => '', ip: "192.168.56.5"
      vmHost2.vm.network "private_network", :name => '', ip: "192.168.56.106"
      
      # Comparto la carpeta del host donde estoy parado contra la vm
      vmHost2.vm.synced_folder 'compartido_Host2/', '/home/vagrant/compartido'
  
    # Agrega la key Privada de ssh en .vagrant/machines/default/virtualbox/private_key
    vmHost2.ssh.insert_key = true
    vmHost2.vm.provider "virtualbox" do |vb2|
      vb2.memory = "1024"
      vb2.name = "vmHost2"
      vb2.cpus = 1
      vb2.linked_clone = true
      # Seteo controladora Grafica
      vb2.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    end
    
    
    # Puedo Ejecutar un script que esta en un archivo
    vmHost2.vm.provision "shell", path: "script_Enable_ssh_password.sh"
    
    # Provisión para instalar
    vmHost2.vm.provision "shell", inline: <<-SHELL
      dnf install -y /home/vagrant/compartido/tree-1.8.0-10.el9.x86_64.rpm
      dnf install git -y 
      dnf install vim -y
      dnf install sshpass -y	
      subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
      dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    SHELL
  end
end