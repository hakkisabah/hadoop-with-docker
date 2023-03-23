FROM ubuntu:20.04

WORKDIR /
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
apt-get install nano -y && \
apt-get install wget -y && \
apt-get install openssh-server -y && \
apt-get install openssh-client -y && \
apt-get install openjdk-8-jdk -y && \
# Select time zone
# 8 is Europe and 20 is Istanbul
printf '8\n' && \
printf '20\n'
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
RUN tar -xzvf hadoop-3.2.2.tar.gz
RUN mv hadoop-3.2.2 /usr/local/hadoop
ENV JV_HME="export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre"
RUN echo $JV_HME >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HADOOP_SECURE_DN_USER=yarn
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root
RUN mkdir ~/input
RUN cp /usr/local/hadoop/etc/hadoop/*.xml ~/input
RUN /usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.2.jar grep ~/input ~/grep_example 'allowed[.]*'
#expect some output
RUN cat ~/grep_example/*
RUN mkdir /usr/local/hadoop/hdir
RUN mkdir /usr/local/hadoop/hdir/namenode
RUN mkdir /usr/local/hadoop/hdir/datanode
COPY ./conf/*.* /usr/local/hadoop/etc/hadoop/
RUN /usr/local/hadoop/bin/hadoop -h
RUN hdfs namenode -format && \
printf 'N\n'


