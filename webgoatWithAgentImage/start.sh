#!/bin/bash

cd /home/webgoat 
service nginx start
sleep 1
echo "Starting WebGoat..."
java -Duser.home=/home/webgoat -Dfile.encoding=UTF-8 \
-javaagent:/cibin/fuzzing_agent_deploy.jar=tls=true,api_token=CI_FUZZ_API_TOKEN,instrumentation_includes="org.owasp.webgoat.**",fuzzing_server_host=172.17.0.1,service_name=projects/organizations_89d295318b3fded6_webgoat_git-95e1f92d/web_services/webgoat \
-jar webgoat.jar --webgoat.build.version=$1 --server.address=0.0.0.0 > webgoat.log &

sleep 10

echo "Starting WebWolf..."
java -Duser.home=/home/webgoat -Dfile.encoding=UTF-8 -jar webwolf.jar --webgoat.build.version=$1 --server.address=0.0.0.0 > webwolf.log &

echo "Browse to http://localhost" to get started >> webgoat.log

tail -300f webgoat.log
