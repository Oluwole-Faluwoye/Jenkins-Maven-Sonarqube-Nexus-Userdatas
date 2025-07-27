yum update -y

amazon-linux-extras install java-openjdk11 -y 

wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo

yum install -y apache-maven

/usr/sbin/alternatives --config java

mvn -v

rm .bash_profile

wget https://raw.githubusercontent.com/awanmbandi/realworld-cicd-pipeline-project/jenkins-master-client-config/.bash_profile

source .bash_profile

cat .bash_profile

#After updating your settings.xml file with the credentials of your Nexus and pushing it into your github repo, you need to download into your Jenkins/Maven instance