# Dockerfile
FROM tomcat:9.0

# Copy your application to the webapps directory (if needed)
# COPY ./your-app.war /usr/local/tomcat/webapps/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
