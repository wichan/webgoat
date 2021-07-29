FROM webgoat/goatandwolf

COPY fuzzing_agent_deploy.jar /fuzzing_agent_deploy.jar

EXPOSE 8080

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom","-javaagent:/fuzzing_agent_deploy.jar=instrumentation_includes=org.dummy.**:org.owasp.**,fuzzing_server_host=172.17.0.1,service_name=projects/webgoat-9af348c1/web_services/webgoat", "-jar", "/home/webgoat/webgoat.jar"]
CMD ["--server.port=8080", "--server.address=0.0.0.0"]
