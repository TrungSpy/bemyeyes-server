sudo docker run -d -e LOGSTASH_CONFIG_URL="https://gist.githubusercontent.com/khebbie/42d72d212cf3727a03a0/raw/aae3cae7d9093560205e353c2439934a59cfa223/logstash.conf"  -p 9292:9292 -p 9200:9200 -p 9300:9300  -p 3334:3334/udp pblittle/docker-logstash