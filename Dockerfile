# Use the official Tomcat image from Docker Hub
FROM tomcat:9.0

# Set environment variables (optional)
ENV TOMCAT_HOME /usr/local/tomcat

# Expose the default Tomcat port (8080)
EXPOSE 8080

# Copy your WAR file into the Tomcat webapps directory (replace "your-app.war" with your WAR file)
COPY ./your-app.war /usr/local/tomcat/webapps/your-app.war

# Optional: If you have specific configurations, copy them to the appropriate directories
# COPY ./server.xml /usr/local/tomcat/conf/server.xml
# COPY ./web.xml /usr/local/tomcat/webapps/your-app/WEB-INF/web.xml

# Start Tomcat server when the container runs
CMD ["catalina.sh", "run"]

