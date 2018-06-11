#!/usr/bin/env bash


VERSION=0.10.0-SNAPSHOT
TEZ_JOB_FINISH="TEZ JOB FINISHED"
SCRIPTS_PATH=scripts
HADOOP_VERSION=3.1.0
HADOOP_URL=http://www-us.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

assure_hadoop() {
    # Download only if the file doesn't exist
    wget -nc $HADOOP_URL
}

assure_tez() {
    if [ ! -f $SCRIPTS_PATH/assure_tez.sh ]; then
        echo "File $SCRIPTS_PATH/assure_tez.sh should exist"
        echo "It should generate the file ter.tar.gz in the root directory"
        echo "If a file already exists generate a noop file"
        echo "If you have local distribution you want to test"
        echo "that script is a good place to compile it and move"
        echo "it to ./ter.tar.gz. Otherwise download it and rename it"
        exit 1
    fi
    source $SCRIPTS_PATH/assure_tez.sh
}

assure_hadoop
assure_tez

echo "Killing previous server and pull script"
ps aux | grep SimpleHTTPServer | awk '{print $2}' | xargs kill -9
ps aux | grep forever_pull_logs.sh | awk '{print $2}' | xargs kill -9

rm -rf logs nohup.out

echo "Tearing down old docker instances"
docker-compose down

echo "Manually deleting kerberos volume"
docker volume rm hadoop-kerberos_server-keytab

echo "Bringing up the docker instances"
docker-compose up -d --force-recreate --build

echo "Getting logs"
source $SCRIPTS_PATH/pull_logs.sh
