#!/bin/bash

# move to wordpress install dir
cd ${NGINX_ROOT_DIR}/${WORDPRESS_INSTALL_DIR}

if [ ! "$(wp core is-installed 2> /dev/null)" ]; then
    # Clean up existing WordPress files
    rm -rf ./*
    chmod -R 777 .

    wp --info

    # wp core download
    CORE_DOWNLOAD="wp core download"
    [ -n "$WORDPRESS_INSTALL_DIR"  ] && CORE_DOWNLOAD+=" --path=\"$NGINX_ROOT_DIR/$WORDPRESS_INSTALL_DIR\""
    [ -n "$WORDPRESS_CORE_DOWNLOAD_LOCALE" ] && CORE_DOWNLOAD+=" --locale=\"$WORDPRESS_CORE_DOWNLOAD_LOCALE\""
    [ -n "$WORDPRESS_CORE_DOWNLOAD_VERSION" ] && CORE_DOWNLOAD+=" --version=\"$WORDPRESS_CORE_DOWNLOAD_VERSION\""
    [ "$WORDPRESS_CORE_DOWNLOAD_SKIP_CONTENT" = "true" ] && CORE_DOWNLOAD+=" --skip-content"
    [ "$WORDPRESS_CORE_DOWNLOAD_FORCE" = "true" ] && CORE_DOWNLOAD+=" --force"
    [ "$WORDPRESS_CORE_DOWNLOAD_INSECURE" = "true" ] && CORE_DOWNLOAD+=" --insecure"
    [ "$WORDPRESS_CORE_DOWNLOAD_EXTRACT" = "true" ] && CORE_DOWNLOAD+=" --extract"
    CORE_DOWNLOAD+=" --allow-root"
    eval "$CORE_DOWNLOAD"

    # wp config create
    # Enable WP_DEBUG and WP_DEBUG_LOG
    wp config create \
        --dbhost="${MYSQL_HOST_NAME}:${MYSQL_PORT}" \
        --dbname="${MYSQL_DATABASE_NAME}" \
        --dbuser="${MYSQL_DATABASE_USER}" \
        --dbpass="${MYSQL_DATABESE_PASSWORD}" \
        --allow-root

    # wp db create
    # データベースの状態を確認
    if wp db check; then
        echo "データベースは存在します。"
    else
        echo "データベースが存在しないため、新しいデータベースを作成します。"
        wp db create
    fi

    wp core install \
        --url="http://${NGINX_SERVER_NAME}" \
        --title="${WORDPRESS_SITE_TITLE}" \
        --admin_user="${WORDPRESS_USER}" \
        --admin_password="${WORDPRESS_USER_PASSWORD}" \
        --admin_email="${WORDPRESS_USER_EMAIL}" \
        --skip-email \
        --allow-root

    wp language core install ja --activate --allow-root
    wp option update timezone_string 'Asia/Tokyo' --allow-root
    wp option update date_format 'Y-m-d' --allow-root
    wp option update time_format 'H:i' --allow-root
    wp option update blogdescription '' --allow-root
    wp option update permalink_structure "/%post_id%/" --allow-root
fi

if [ "${WORDPRESS_DEVELOP_MODE}" = "plugin" ]; then
    if wp plugin is-installed "${WORDPRESS_PLUGIN_SLUG}" ; then
        echo "Plugin${WORDPRESS_PLUGIN_SLUG}は既にインストールされています。"
        php-fpm
    else
        # 環境変数の存在チェックと設定
        if [ -n "$WORDPRESS_PLUGIN_SLUG" ]; then
            PLUGIN_COMMAND="wp scaffold plugin \"$WORDPRESS_PLUGIN_SLUG\""
            # WORDPRESS_PLUGIN_DIRが存在する場合は --dir オプションを追加
            [ -n "$WORDPRESS_PLUGIN_DIR" ] && PLUGIN_COMMAND+=" --dir=\"$WORDPRESS_PLUGIN_DIR\""
            [ -n "$WORDPRESS_PLUGIN_NAME" ] && PLUGIN_COMMAND+=" --plugin_name=\"$WORDPRESS_PLUGIN_NAME\""
            [ -n "$WORDPRESS_PLUGIN_DESCRIPTION" ] && PLUGIN_COMMAND+=" --plugin_description=\"$WORDPRESS_PLUGIN_DESCRIPTION\""
            [ -n "$WORDPRESS_PLUGIN_AUTHOR" ] && PLUGIN_COMMAND+=" --plugin_author=\"$WORDPRESS_PLUGIN_AUTHOR\""
            [ -n "$WORDPRESS_PLUGIN_AUTHOR_URL" ] && PLUGIN_COMMAND+=" --plugin_author_uri=\"$WORDPRESS_PLUGIN_AUTHOR_URL\""
            [ -n "$WORDPRESS_PLUGIN_URI" ] && PLUGIN_COMMAND+=" --plugin_uri=\"$WORDPRESS_PLUGIN_URI\""
            [ "$WORDPRESS_PLUGIN_SKIP_TEST" = "true" ] && PLUGIN_COMMAND+=" --skip-tests"
            [ -n "$WORDPRESS_PLUGIN_CI_PROVIDER" ] && PLUGIN_COMMAND+=" --ci=\"$WORDPRESS_PLUGIN_CI_PROVIDER\""
            [ "$WORDPRESS_PLUGIN_ACTIVATE" = "true" ] && PLUGIN_COMMAND+=" --activate"
            [ "$WORDPRESS_PLUGIN_ACTIVATE_NETWORK" = "true" ] && PLUGIN_COMMAND+=" --activate-network"
            [ "$WORDPRESS_PLUGIN_FORCE" = "true" ] && PLUGIN_COMMAND+=" --force"
            # 最終的なコマンドを実行
            eval "$PLUGIN_COMMAND"
        else
            echo "WORDPRESS_PLUGIN_SLUGが設定されていません。処理を中止します。"
            exit 1
        fi
    fi
fi

php-fpm
