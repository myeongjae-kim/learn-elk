# EC2에 docker로 ELK Stack 올리고 webapp의 로그와 연결하기

1. ec2의 security group에서 5601 port 열기 (Kibana)
2. 이후 아래 커맨드 참고해서 셋팅

```sh
sudo yum install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl status firewalld
sudo firewall-cmd --zone=public --add-port=5601/tcp --permanent
sudo firewall-cmd --reload

sudo amazon-linux-extras install java-openjdk11
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

git clone https://github.com/myeongjae-kim/learn-elk
cd learn-elk/
cd webapp/
./gradlew build
cd build
cd libs
sudo mkdir /kiworkshop
sudo mv webapp-0.0.1-SNAPSHOT.jar /kiworkshop/
cd /
sudo chown ec2-user kiworkshop
cd kiworkshop
ls -al
nohup java -Dreactor.netty.http.server.accessLogEnabled=true -jar webapp-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod &

curl localhost:8080/logs/warn
cd spring
cat spring.log 
cd ..
cd netty/
cat access_log.log 

# install filebeat
cd
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.9.2-x86_64.rpm
sudo rpm -vi filebeat-7.9.2-x86_64.rpm

# filebeat.yml파일 열어서 아래 값들 찾아서 변경
#
# filebeat.inputs:
# - type: log
#   enabled: true
#
#   paths:
#     #- /var/log/*.log
#     - /kiworkshop/spring/spring.log
#     - /kiworkshop/netty/access_log.log
#
# output.elasticsearch:
#   hosts: ["localhost:9200"]
#   username: "elastic"
#   password: "changeme"

cd /etc/filebeat
sudo vi filebeat.yml # https://www.elastic.co/guide/en/beats/filebeat/current/configuration-filebeat-options.html

sudo filebeat setup -e
sudo service filebeat start

#### 이하부터는 잘 안됨..

cd
wget https://packages.elastic.co/curator/5/centos/7/Packages/elasticsearch-curator-5.8.1-1.x86_64.rpm
sudo rpm -U elasticsearch-curator-5.8.1-1.x86_64.rpm
mkdir .curator
cd curator
echo "---
# Remember, leave a key empty if there is no value.  None will be a string,
# not a Python "NoneType"
client:
  hosts:
    - 127.0.0.1
  port: 9200
  url_prefix:
  use_ssl: False
  certificate:
  client_cert:
  client_key:
  ssl_no_validate: False
  http_auth: 'elastic:changeme'
  timeout: 30
  master_only: False

logging:
  loglevel: INFO
  logfile:
  logformat: default
  blacklist: ['elasticsearch', 'urllib3']" > curator.yml

cd
echo "---
actions:
  1:
    action: delete_indices
    description: >-
      Delete indices older than 30 days (based on index name), for filebeat-
      prefixed indices. Ignore the error if the filter does not result in an
      actionable list of indices (ignore_empty_list) and exit cleanly.
    options:
      ignore_empty_list: True
      timeout_override:
      continue_if_exception: False
      disable_action: False
    filters:
    - filtertype: pattern
      kind: prefix
      value: filebeat-
      exclude:
    - filtertype: age
      source: name
      direction: older
      timestring: '%Y.%m.%d'
      unit: days
      unit_count: 0
      exclude:" > delete_indices_time_base.yml

curator delete_indices_time_base.yml

# Alarm은 Open Distro Alert 설치해서 사용한다. https://woowabros.github.io/experience/2020/01/16/set-elk-with-alarm.html#open-distro-설치하기 참고
# 현재 Open Distro Alert 최신 버전은 1.10.0  지원하는 ELK 버전은 7.9.1이다
# .env에서 버전을 7.9.1로 변경하고 Open Distro 다운로드 주소는 https://d3g5vo6xdbdb9a.cloudfront.net/downloads/elasticsearch-plugins/opendistro-security/opendistro_security-1.10.1.0.zip
# https://opendistro.github.io/for-elasticsearch-docs/docs/install/plugins/

```
