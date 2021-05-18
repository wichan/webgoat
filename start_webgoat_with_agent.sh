#!/bin/bash

web_service_base_name="fuzz_WebGoat"
web_service_line=($(cictl list webservices | grep $web_service_base_name))
web_service_name=${web_service_line[0]}
if [ -z "$web_service_name" ]
then
	echo "Did not find $web_service_base_name in list of web services."
      exit 1
fi
java -javaagent:$HOME/bin/fuzzing_agent_deploy.jar=instrumentation_includes="org.owasp.**",service_name=$web_service_name -jar webgoat-server/target/webgoat-server-8.0.0-SNAPSHOT.jar
