#!/bin/bash

# move to wordpress install dir
cd "${WORDPRESS_ROOT_DIR}"
if [ -f wp-config.php ]; then
    echo "WordPressはすでにインストールされています。php-fpmを起動します。"
    php-fpm
else
    # Add the following lines in the wp-install.sh script before the WordPress installation part
    # Clean up existing WordPress files
    rm -rf ./*
    # Make the directory writable
    chmod -R 777 .
    wp --info
    wp core download --allow-root
    wp config create --dbhost="${MYSQL_HOST_NAME}:${MYSQL_PORT}" --dbname="${MYSQL_DATABASE_NAME}" --dbuser="${MYSQL_DATABASE_USER}" --dbpass="${MYSQL_DATABESE_PASSWORD}" --allow-root
    wp db create
    wp core install \
    --url="http://${WORDPRESS_LOCAL_URL}:${WORDPRESS_LOCAL_PORT}" \
    --title="${WORDPRESS_SITE_TITLE}" \
    --admin_user="${WORDPRESS_USER}" \
    --admin_password="${WORDPRESS_USER_PASSWORD}" \
    --admin_email="${WORDPRESS_USER_EMAIL}" \
    --allow-root
    wp language core install ja --activate --allow-root
    wp option update timezone_string 'Asia/Tokyo' --allow-root
    wp option update date_format 'Y-m-d' --allow-root
    wp option update time_format 'H:i' --allow-root
    wp option update blogdescription '' --allow-root
    wp option update permalink_structure "/%post_id%/" --allow-root

    if [ "${WORDPRESS_DEVELOP_MODE}" = "plugin" ]; then
        WPCLI_COMMAND="wp scaffold plugin \"${WORDPRESS_PLUGIN_SLUG}\""
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_DIR}" ? " --dir=\"${WORDPRESS_PLUGIN_DIR}\"" : ""))
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_NAME}" ? " --plugin_name=\"${WORDPRESS_PLUGIN_NAME}\"=" : ""))
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_DESCRIPTION}" ? " --plugin_description=\"${WORDPRESS_PLUGIN_DESCRIPTION}\"=" : ""))
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_AUTHOR}" ? " --plugin_author=\"${WORDPRESS_PLUGIN_AUTHOR}\"=" : ""))
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_AUTHOR_URL}" ? " --plugin_author_uri=\"${WORDPRESS_PLUGIN_AUTHOR_URL}\"" : ""))
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_URI}" ? " --plugin_uri=\"${WORDPRESS_PLUGIN_URI}\"" : ""))
        WPCLI_COMMAND+=$(("${WORDPRESS_PLUGIN_SKIP_TEST}" = "true" ? " --skip-tests" : ""))
        WPCLI_COMMAND+=$((-n "${WORDPRESS_PLUGIN_CI_PROVIDER}" ? " --ci=\"${WORDPRESS_PLUGIN_CI_PROVIDER}\"" : ""))
        WPCLI_COMMAND+=$(("${WORDPRESS_PLUGIN_ACTIVATE}" = "true" ? " --activate" : ""))
        WPCLI_COMMAND+=$(("${WORDPRESS_PLUGIN_ACTIVATE_NETWORK}" = "true" ? " --activate-network" : ""))
        WPCLI_COMMAND+=$(("${WORDPRESS_PLUGIN_FORCE}" = "true" ? " --force" : ""))
        echo "$WPCLI_COMMAND"
        # 実行
        eval "$WPCLI_COMMAND"
    fi
    php-fpm
fi
