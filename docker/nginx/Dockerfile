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
# Copy Nginx configuration file and apply envsubst
ARG APP_ENV=development
COPY default.${APP_ENV}.conf /etc/nginx/conf.d/default.conf.template
CMD /bin/sh -c "envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"