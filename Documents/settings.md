# 作業内容

## 20210323

**_ssh接続の設定_**

```
# keyの作成
ssh-keygen -t rsa

# 公開鍵をコピー
ssh-copy-id -i ~/.ssh/id_irdc_rsa.pub irdc-saga-u@irdc-saga-u.sakura.ne.jp

# configの修正
vim ~/.ssh/config

# 追記
# Host irdc
#   HostName irdc-saga-u.sakura.ne.jp
#   user irdc-saga-u
#   IdennityFile ~/.ssh/id_irdc_rsa

# server wp-content DIR path
/home/irdc-saga-u/www/irdc/wp-content

# サーバーファイルのコピー
scp -r irdc:/home/irdc-saga-u/www/irdc/wp-content/themes/ ./
scp -r irdc:/home/irdc-saga-u/www/irdc/wp-content/plugins/ ./
```

# 課題

- Dockerfileにphp.iniをマウントさせるような仕組みを記述する
- scp等のコマンドで本番環境からファイルをダウンロードできるようにapt-getでsshをインストールしておく
- wordpressの設定手順をマニュアル化する
- gitignoreを更新して必要なファイルのみを更新対象にする
- sassをビルドできるようにnvmとnodeを入れる。apt-get install sassをする