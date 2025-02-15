FROM amazonlinux
RUN yum install java tar gzip -y
WORKDIR /opt
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz .

RUN tar -xvf apache-tomcat-9.0.96.tar.gz && rm apache-tomcat-9.0.96.tar.gz

RUN sed -i 's/""127\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1"/".*"/g' /opt/apache-tomcat-9.0.96/webapps/manager/META-INF/context.xml
WORKDIR /opt/apache-tomcat-9.0.96/conf/
RUN rm -rf tomcat-users.xml
RUN echo '<?xml version='1.0' encoding='utf-8'?> \
       <tomcat-users> \
       <role rolename="manager-gui"/> \
       <user username="tomcat" password="Tomcat" roles="manager-gui, manager-script, manager-status"/> \
       </tomcat-users>' > tomcat-users.xml

CMD ["/opt/apache-tomcat-9.0.96/bin/catalina.sh", "run"]

EXPOSE 8080
