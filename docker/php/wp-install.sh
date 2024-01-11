#!/bin/bash
# move to wordpress install dir
cd ${WORDPRESS_ROOT_DIR}

wp --info

wp db create --path=/var/www/html --allow-root

# WordPressセットアップ admin_user,admin_passwordは管理画面のログインID,PW
wp core install \
--url="http://"${WORDPRESS_LOCAL_URL}":"${WORDPRESS_LOCAL_PORT} \
--title="${WORDPRESS_SITE_TITLE}" \
--admin_user="${WORDPRESS_USER}" \
--admin_password="${WORDPRESS_USER_PASSWORD}" \
--admin_email="${WORDPRESS_USER_EMAIL}" \
--allow-root

# 日本語化
wp language core install ja --activate --allow-root

# タイムゾーンと日時表記
wp option update timezone_string 'Asia/Tokyo' --allow-root
wp option update date_format 'Y-m-d' --allow-root
wp option update time_format 'H:i' --allow-root

# キャッチフレーズの設定 (空にする)
wp option update blogdescription '' --allow-root

# プラグインの削除 (不要な初期プラグインを削除)
wp plugin delete hello.php --allow-root
wp plugin delete akismet --allow-root

# テーマの有効化
wp theme list --allow-root

# パーマリンク更新
wp option update permalink_structure "/%post_id%/" --allow-root

# 本来のWordPressエントリーポイントを実行
docker-entrypoint.sh apache2-foreground