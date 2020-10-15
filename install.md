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
sudo docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch
sudo docker-compose up -d

# Failed to Setup IP tables: Unable to enable SKIP DNAT rule: (iptables failed: iptables –wait -t nat -I DOCKER -i br-24d7aa7869f4 -j RETURN: iptables: No chain/target/match by that name. (exit status 1)) 인 경우 해결책
# https://forums.docker.com/t/failed-to-setup-ip-tables-unable-to-enable-skip-dnat-rule-iptables-failed-iptables-wait-t-nat-i-docker-i-br-24d7aa7869f4-j-return-iptables-no-chain-target-match-by-that-name-exit-status-1/73080
systemctl stop docker
sudo systemctl stop docker
sudo pkill docker
sudo iptables -t nat -F
sudo ifconfig docker0 down
sudo brctl delbr docker0
sudo systemctl start docker


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
```
