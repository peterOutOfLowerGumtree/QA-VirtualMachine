#!/usr/bin/env bash
#Install Java, maven and git

### Copy files ###
cd /vagrant_data
sudo scp /vagrant_data/notforgit/jira.bin /opt/
# sudo scp /vagrant_data/notforgit/nexus-3.0.2-02-unix.tar.gz /opt
cd /opt

### Install Java ###
yes | sudo add-apt-repository ppa:webupd8team/java
sudo apt update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt install -y oracle-java8-installer
javac -version
sudo apt install oracle-java8-set-default
echo "Installed Java"

### Install Jenkins ###
sudo wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins
echo "Installed Jenkins"

### Set up Jenkins ###
sudo chmod -R 755 /var/lib/jenkins/secrets
sudo su jenkins -s /bin/bash
ssh-keygen
printf '/vagrant_data/key_test\n\n\n'
echo "vagrant" | su vagrant
sudo service jenkins start
echo "Set up Jenkins"

### Install Jira ###
sudo chmod a+x jira.bin
sudo printf 'o\n2\n\n\n2\n8082\n8007\ny\n' | ./jira.bin
echo "Installed Jira"

### Install Apache2 & Git ###
sudo apt-get install -y apache2
sudo apt-get install -y git
echo "Installed Apache2 and Git"

### Install SBT ###
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt
echo "Installed SBT"

### Install Nexus ###
sudo wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.0.2-02-unix.tar.gz
sudo tar -xvf nexus-3.0.2-02-unix.tar.gz
sudo mv nexus-3.0.2-02 nexus
cd nexus/bin
sudo RUN_AS_USER=root ./nexus start
cd /opt
echo "Installed Nexus"

### Install Zabbix {Doesn't work as of 17:34, 06/07/2017 - asks for prompts} ###
wget http://repo.zabbix.com/zabbix/2.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.4-1+trusty_all.deb 
sudo dpkg -i zabbix-release_2.4-1+trusty_all.deb
sudo apt-get install -y zabbix-server-mysql zabbix-frontend-php php5-mysql
echo "Installed Zabbix"

### Check Installations
echo "Checking installations.."
sudo apt update
java -version
sudo service jenkins status
ps -ef | grep JIRA
git --version
apachectl -V
sbt sbtVersion
sbt sbtVersion

echo "Installs successful"
echo ""
echo "Next steps for Jenkins:"
echo "1. Check ip address"
echo "2. In Firefox, enter <your_ip>:8080"
echo "3. Enter password from /var/lib/jenkins/secrets/initialAdminPassword.<extension>"

