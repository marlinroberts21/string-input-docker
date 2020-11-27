# IMPORTANT: This Dockerfile accesses a repository that is currently private.
# The username and password on line 23 need to be replaced with credentials for that repository.

# Start with a Ubuntu LTS (https://wiki.ubuntu.com/LTS) base image (i.e., the one from April 2018),
FROM ubuntu:18.04

# update available package lists for Ubuntu
RUN apt-get update

# install the Java OpenJDK 8 (not the Oracle Java JDK 8, which requires a license)
# the Java JDK includes the Java JRE as well
RUN apt install -y openjdk-8-jdk

# install git to be able to clone the heroku startup repository
RUN apt install -y git

# install maven to be able to build the heroku startup repository
RUN apt install -y maven

# switch back to the root user for the remaining commands
USER root


#
#
# IMPORTANT: replace username and password with credentials for private directory
RUN git clone https://username:password@github.com/marlinroberts21/string-constraint-inputs.git
#
#
#

# all future commands will be relative to the cloned repository
WORKDIR /string-constraint-inputs

# reset to correct commit
RUN git reset --hard 767a30d9e2f0525bd4ac650046891a360f7974f2

# build the jar
RUN mvn install -Preproduce

# directory for jar and json files
RUN mkdir reproduce

# copy jar and json files to same directory
RUN cp ./target/inverse-testing-1.0-SNAPSHOT-jar-with-dependencies.jar ./reproduce/inv-solver.jar
RUN cp ./graphs/benchmarks/inverse_case*.json ./reproduce

# copy runme script with usage instructions, set working directory and permissions.
COPY runme.sh ./reproduce
WORKDIR /string-constraint-inputs/reproduce
RUN chmod +x runme.sh

# start with a bash shell
RUN /bin/bash
