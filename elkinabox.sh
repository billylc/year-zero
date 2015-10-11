#!/bin/bash
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install python-pip -y
sudo pip install awscli
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
sudo apt-get update
sudo apt-get -y install elasticsearch=1.4.5
cd /usr/share/elasticsearch
sudo ./bin/plugin -install mobz/elasticsearch-head
sudo ./bin/plugin -install lukas-vlcek/bigdesk
sudo ./bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.7.1
sudo ./bin/plugin -install elasticsearch/marvel/latest
sudo ./bin/plugin -install lmenezes/elasticsearch-kopf
#sudo vi /etc/elasticsearch/elasticsearch.yml 
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10


#KIBANA
cd ~; wget https://download.elasticsearch.org/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz
tar xvf kibana-4.1.2-linux-x64.tar.gz 
#vi ~/kibana-4.1.2-linux-x64/config/kibana.yml 
sudo mkdir -p /opt/kibana
sudo cp -R ~/kibana-4.1.2-linux-x64/* /opt/kibana/
/opt/kibana/bin/kibana 
cd /etc/init.d && sudo wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
sudo chmod +x /etc/init.d/kibana4 
sudo update-rc.d kibana4 defaults 96 9
sudo service kibana4 start

#LOGSTASH
sudo echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
echo "deb http://packages.elasticsearch.org/logstash/1.5/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install logstash
wget -O titanic.json -v -t 2 --timeout 10 wget http://mysafeinfo.com/api/data?list=titanicsudo chmod +x /etc/init.d/logstash
sudo update-rc.d logstash defaults 97 8
sudo service logstash start
sudo service logstash stop
sudo apt-get install python-setuptools
sudo easy_install pip
sudo pip install elasticsearch
sudo service logstash start
wget https://raw.githubusercontent.com/sloanahrens/qbox-blog-code/master/ch_1_local_ubuntu_es/build_index.py
python build_index.py 

#shakespeare
curl -XPUT http://localhost:9200/shakespeare -d ' { "mappings" : { "_default_" : { "properties" : { "speaker" : {"type": "string", "index" : "not_analyzed" }, "play_name" : {"type": "string", "index" : "not_analyzed" }, "line_id" : { "type" : "integer" }, "speech_number" : { "type" : "integer" } } } } }';
cd 
json will_play_text.json
curl https://commondatastorage.googleapis.com/ckannet-storage/2012-04-24T183728/will_play_text.json -O


aws s3 cp s3://elk-standup-dev/shakespeare.json.zip .
sudo apt-get install unzip -y
unzip shakespeare.json.zip
curl -XPUT localhost:9200/_bulk --data-binary @shakespeare.json
instance_id=`curl http://169.254.169.254/latest/meta-data/instance-id`
echo $instance-id
external_ip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
