# docker/vue/Dockerfile

# Specify base image
FROM node:lts

# Working Directory Settings
WORKDIR /app

# node.js の環境変数を定義する
# 本番環境では production
ENV NODE_ENV=${APP_ENV}

# install vue-cli
RUN npm install -g @vue/cli
RUN npm init -y && \
    npm install --save-dev @wordpress/create-block

# ポート3000を公開（Vue.jsのデフォルトの開発サーバーのポート）
EXPOSE ${VUE_PORT}