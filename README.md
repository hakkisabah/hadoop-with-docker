## < hadoop-with-docker >
# Use hadoop on all operating systems running Docker!

### Requirement
- Docker(included docker-compose)

### Setup Steps
- Type this In your terminal  => `git clone https://github.com/hakkisabah/hadoop-with-docker.git`
- Open Docker and follow => `Settings > Resources > File Sharing` and add local path of repository folder
- Type to terminal  => `docker-compose up -d` and wait for completing(done message)

### Example Steps
- After completed compose up => `docker exec -it hadoop_docker "bin/bash"` enter your hadoop container
- In your container bash, follow this commands :
- - `service ssh start`
- - `start-dfs.sh`
- - `start-yarn.sh`
- - `echo "my first test for hadoop with docker and docker really super!" >> test.txt`
- - `hadoop fs -mkdir -p "/user/$(whoami)"`
- - `hadoop fs -copyFromLocal test.txt`
- - `hadoop fs -mkdir Document1`
- - `hadoop fs -cp test.txt Document1`
- - `hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.2.jar wordcount Document1 output`
- - `hadoop fs -ls output` (optional)
- - `hadoop fs -cat output/part-r-00000` (example of option)
- - `hadoop fs -copyToLocal output ~/output` (example of option for if you want copy to your system local)

