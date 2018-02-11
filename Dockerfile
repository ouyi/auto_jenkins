FROM jenkins/jenkins:lts-alpine
 
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
 
COPY security.groovy /var/jenkins_home/init.groovy.d/security.groovy
COPY csrf.groovy /var/jenkins_home/init.groovy.d/csrf.groovy
 
COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

RUN apk --update add python
