# EC2에 docker로 ELK Stack 올리고 MySQL에서 데이터 가져오기

1. ec2의 security group에서 5601 port 열기 (Kibana)
2. 이후 아래 커맨드 참고해서 셋팅

```sh
# 5601번 포트 열고 docker-elk 설치해서 실행
sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld
sudo firewall-cmd --zone=public --add-port=5601/tcp --permanent
sudo firewall-cmd --reload

sudo amazon-linux-extras install java-openjdk11 -y
sudo yum -y update
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo yum -y install git
git clone https://github.com/deviantony/docker-elk.git

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

cd docker-elk/

vi ./elasticsearch/config/elasticsearch.yml # xpack.license.self_generated.type: basic
sudo docker-compose up -d

cd logstash
vi Dockerfile

# 아래 커맨드 제일 마지막줄에 추가
# RUN cd ~ && yum -y update && yum -y install wget && \
#        wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.22.tar.gz && \
#        tar -xzvf mysql-connector-java-8.0.22.tar.gz && \
#        mv mysql-connector-java-8.0.22/mysql-connector-java-8.0.22.jar . &&\
#        rm -rf mysql-connector-java-8.0.22 mysql-connector-java-8.0.22.tar.gz &&\
#        ls -al

# mysql 설치
sudo docker pull mysql
sudo docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d -p 3306:3306 mysql:latest 

sudo docker exec -it 18f663b9c853 /bin/bash
mysql -u root -p
my-secret-pw

ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'my-secret-pw';

CREATE DATABASE es_db CHARACTER SET utf8mb4 collate utf8mb4_general_ci;
use es_db

# 이후에 mhk_dummy.sql 참조

# host에서 접속하려면
mysql -h 0.0.0.0 -u root -p
my-secret-pw

# logstash pipeline 변경
cd ~/docker-elk/logstash/pipeline
vi logstash.conf

# https://www.elastic.co/kr/blog/how-to-keep-elasticsearch-synchronized-with-a-relational-database-using-logstash 참고해서 업데이트
# docker container에서 host의 ip로 연결하는게 문제임... 그냥 inernal ip를 사용했음

# 다음주에 해야 할 것: query수정하고 파이프라인 나머지부분 추가하기


```
