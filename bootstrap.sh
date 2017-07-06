#!/usr/bin/env bash
#Install Java, maven and git

### Copy files ###
cd /vagrant_data
sudo scp /vagrant_data/notforgit/jira.bin /opt/
cd /opt

### Install Java ###
echo "Installing Java"
yes | sudo add-apt-repository ppa:webupd8team/java
sudo apt update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt install -y oracle-java8-installer
javac -version
sudo apt install oracle-java8-set-default

### Install Jenkins ###
echo "Installing Jenkins"
sudo wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins

### Set up Jenkins ###
echo "Setting up Jenkins"
sudo chmod 755 /var/lib/jenkins/secrets
sudo su jenkins -s /bin/bash
ssh-keygen
printf '/vagrant_data/key_test\n\n\n'
su vagrant
printf 'vagrant'
sudo service jenkins start


### Install Jira ###
echo "Installing Jira"
sudo chmod a+x jira.bin
sudo printf 'o\n2\n\n\n2\n8081\n8006\ny\n' | ./jira.bin

### Install Apache2 & Git ###
echo "Installing Apache2 and Git"
sudo apt-get install -y apache2
sudo apt-get install -y git

### Install SBT ###
echo "Installing SBT"
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt

# ### Check Installations
java -version
sudo service jenkins status
ps -ef | grep JIRA
git --version
apachectl -V
sbt sbtVersion
sbt sbtVersion

echo "Installs complete"
echo ""
echo "Next steps for Jenkins:"
echo "1. Check ip address"
echo "2. In Firefox, enter <your_ip>:8080"
echo "3. Enter password from /var/lib/jenkins/secrets/initialAdminPassword.<extension>"

