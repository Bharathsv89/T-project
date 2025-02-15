FROM amazonlinux:latest

# Install dependencies
RUN dnf update -y && \
    dnf install -y java-17-amazon-corretto-devel tar gzip && \
    dnf clean all

# Download and install Tomcat
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz && \
    tar -xzf apache-tomcat-9.0.80.tar.gz && \
    mv apache-tomcat-9.0.80 /opt/tomcat && \
    rm apache-tomcat-9.0.80.tar.gz

# Set environment variables
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
