FROM jenkins/jenkins:lts-alpine

USER root
RUN apk --update add python
USER ${user}

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
 
COPY security.groovy /var/jenkins_home/init.groovy.d/security.groovy
COPY csrf.groovy /var/jenkins_home/init.groovy.d/csrf.groovy
 
COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /var/jenkins_home/plugins.txt
