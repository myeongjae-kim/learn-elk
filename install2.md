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
#         wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.22.tar.gz && \
#         tar -xzvf mysql-connector-java-8.0.22.tar.gz && \
#         mkdir /mysql-connector && chown -R 1000:1000 /mysql-connector &&\
#         mv mysql-connector-java-8.0.22/mysql-connector-java-8.0.22.jar /mysql-connector &&\
#         chmod 777 /mysql-connector/mysql-connector-java-8.0.22.jar &&\
#         chown -R 1000:1000 /mysql-connector/mysql-connector-java-8.0.22.jar &&\
#         rm -rf mysql-connector-java-8.0.22 mysql-connector-java-8.0.22.tar.gz &&\
#         ls -al

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
# input {
#         beats {
#                 port => 5044
#         }

#         tcp {
#                 port => 5000
#         }

#   jdbc {
#     jdbc_driver_library => "/mysql-connector/mysql-connector-java-8.0.22.jar"
#     jdbc_driver_class => "com.mysql.jdbc.Driver"
#     jdbc_connection_string => "jdbc:mysql://13.125.66.95:3306/es_db"
#     jdbc_user => "root"
#     jdbc_password => "my-secret-pw"
#     jdbc_paging_enabled => true
#     tracking_column => "unix_ts_in_secs"
#     use_column_value => true
#     tracking_column_type => "numeric"
#     schedule => "*/5 * * * * *"
#     statement => "SELECT *, creation_timestamp AS unix_ts_in_secs FROM title WHERE (creation_timestamp > :sql_last_value AND creation_timestamp < UNIX_TIMESTAMP(NOW())) ORDER BY creation_timestamp ASC"
#   }
# }

# elasticsearch api를 사용하기 위해 인증을 꺼준다.
cd ~/docker-elk/elasticsearch/config
vi elasticsearch.yml
# xpack.security.enabled: false

cd ~/docker-elk
sudo docker-compose build
sudo docker-compose up -d

# 인덱스 생성해서... 알아서 해보자

```

## ElasticSearch api로 검색하기

```bash
# 실제로 사용할 때는 `?pretty`를 없애자
curl -X GET "localhost:9200/logstash-2020.10.21-000001/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "filter": [
        {
          "match_phrase": {
            "title": "동네"
          }
        }
      ]
    }
  }
}
'
```

Response

```json
{
  "took": 1,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 1,
      "relation": "eq"
    },
    "max_score": 0.0,
    "hits": [
      {
        "_index": "logstash-2020.10.21-000001",
        "_type": "_doc",
        "_id": "NUg6b3UB9H4aUWKfB8Ww",
        "_score": 0.0,
        "_source": {
          "creation_timestamp": 1603888874,
          "genre_id": 2,
          "@version": "1",
          "title": "동네 한 바퀴",
          "unix_ts_in_secs": 1603888874,
          "id": 52,
          "@timestamp": "2020-10-28T12:41:15.330Z"
        }
      }
    ]
  }
}
```

## 기타

태그 이름으로도 검색할 수 있게 만들기 위해서는... logstash에서 db의 데이터를 가져올 때 title과 tag를 join해서 가져오면 된다. 그러나 join을 사용하면 필연적으로 성능에 대한 고민을 해야 하므로...

가장 간단한 방법은, logstash가 읽기 전용 replica db를 바라보게 하는것. Heavy한 select query를 사용하더라도 애플리케이션이 사용하는 db에는 영향이 없다.

https://aws.amazon.com/rds/features/read-replicas/
