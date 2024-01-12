# Dockerfile for Nginx

FROM nginx:latest

# Copy Nginx configuration file
ARG APP_ENV=development
# Set TimeZone to Asia/Tokyo
ENV TZ Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
   && dpkg-reconfigure -f noninteractive tzdata

COPY default.${APP_ENV}.conf /etc/nginx/conf.d/default.conf