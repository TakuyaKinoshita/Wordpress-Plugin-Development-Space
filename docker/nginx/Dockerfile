# Dockerfile for Nginx
FROM nginx:latest

# Set TimeZone to Asia/Tokyo
ENV TZ Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
   && dpkg-reconfigure -f noninteractive tzdata

# Install envsubst
RUN apt-get update && \
   apt-get install -y gettext-base && \
   rm -rf /var/lib/apt/lists/*

# Copy Nginx configuration template
ARG APP_ENV=development
COPY default.${APP_ENV}.conf /etc/nginx/conf.d/default.conf.template

# Define a script for environment variable substitution
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the script as an entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]