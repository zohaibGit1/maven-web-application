# Use Ubuntu base Images
ARG baseImageTag=latest
FROM ubuntu:${baseImageTag}

# Build Arguments
ARG user=jenkins
ARG port=8088
ARG groupId=1000

# Enviroment Variable for the Jenkins File
ENV JENKINS_HOME /var/jenkins_home

#Installing the required Dependenices for the jenkins
RUN apt-get update -y &&  \
    apt-get install -y openjdk-17-jdk wget curl && \
    && rm -rf /var/lib/apt/lists/*

# Create the Jenkins User
RUN groupadd -g ${groupId} ${user} && \
    useradd -d ${JENKINS_HOME} -u ${groupId} -g ${user} -m -s /bin/bash ${user}

# Set the Permission
RUN chown -R ${user}:${user} ${JENKINS_HOME}

#Installing the Jenkins Software
RUN wget -o /usr/share/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war

#Switching the User
USER ${user}

#Exposing the Custom Port
EXPOSE ${port}

#RUN Jenkins
CMD["java" ,"-jar" , "/usr/share/jenkins.war" ,"--httpPort=8080"]
