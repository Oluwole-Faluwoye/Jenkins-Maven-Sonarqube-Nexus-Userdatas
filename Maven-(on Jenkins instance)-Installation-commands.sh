Amazon Linux 2023


#!/bin/bash

sudo su

# Update the system
dnf update -y

# Install Java 11 (Amazon Corretto)
dnf install -y java-11-amazon-corretto

# Set Java 11 as default Java version

sudo /usr/sbin/alternatives --config java  # NOTE: Select 1 or 2 for java11

# Verify Java installation (optional interactive, so skip config manually)
java -version

# Download and install Apache Maven (manual install recommended on AL2023)
cd /opt

wget https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz

tar -xvzf apache-maven-3.9.6-bin.tar.gz
ln -s apache-maven-3.9.6 maven

# Set environment variables for Maven and Java
# Load aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Add Maven to PATH
export M2_HOME=/opt/maven
export PATH=$M2_HOME/bin:$HOME/.local/bin:$HOME/bin:$PATH


# Make Maven globally available
echo "export M2_HOME=/opt/maven" >> ~/.bash_profile
echo "export PATH=\$M2_HOME/bin:\$PATH" >> ~/.bash_profile
source ~/.bash_profile

# Verify Maven installation
mvn -v

# Show updated .bash_profile
cat ~/.bash_profile


# Setup Jenkins .m2 directory and Maven settings.xml
mkdir -p /var/lib/jenkins/.m2
wget https://raw.githubusercontent.com/Oluwole-Faluwoye/Jenkins-Maven-Sonarqube-Nexus-AmazonLinux2023/refs/heads/main/settings.xml -P /var/lib/jenkins/.m2/

# Set correct permissions
chown -R jenkins:jenkins /var/lib/jenkins/.m2
chown jenkins:jenkins /var/lib/jenkins/.m2/settings.xml


Jenkins jobs typically run as the jenkins user, not as ec2-user or root. And:

.bash_profile is loaded only in interactive login shells, not in non-interactive CI pipelines.

So even though you ran source ~/.bash_profile, that applies only to your current shell — not to Jenkins.

Also, /opt/maven/bin is likely not in Jenkins’ PATH.

✅ Solutions:
✅  Make Maven available system-wide (Recommended)
Create a file under /etc/profile.d/maven.sh so all users, including jenkins, get the Maven path:



sudo tee /etc/profile.d/maven.sh > /dev/null << 'EOF'
export M2_HOME=/opt/maven
export PATH=$M2_HOME/bin:$PATH
EOF

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh


Then reboot the instance or restart Jenkins to reload the environment:

sudo systemctl restart jenkins