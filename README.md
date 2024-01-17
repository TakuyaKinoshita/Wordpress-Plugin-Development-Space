# README

## development environment

```
# Windows

Docker Desctop
WSL2
VScode
Windows Terminal

# Mac

Docker Desctop for Mac
Terminal
VScode
```

## Setup

1.  Copy the sample.env file and save it as a .env file

```
$ copy sample.env .env
```

2.  Set environment variables in the .env file

```
# Items that must be changed or set
PREFIX=
WORDPRESS_DEVELOP_MODE
```

> [!NOTE]
> `WORDPRESS_DEVELOP_MODE` can be selected from three modes: `plugin`, `theme`, or `empty`, and currently only `plugin` is supported.
> 
> The port number of each application does not conflict with the port of the development PC, so it is recognized as a port number on the Docker Network that can be operated with the same settings as before.

> [!IMPORTANT]
> If you set `WORDPRESS_DEVELOP_MODE` to `plugin` or `theme`, you need to copy and rename either `docker/php/wordpress.plugin.env.sample` or `docker/php/wordpress.theme.env. sample`, depending on the mode you have chosen.
>
> `docker/php/wordpress.plugin.env.sample` rename to `docker/php/wordpress.plugin.env`
>
> `docker/php/wordpress.theme.env.sample` rename to `docker/php/wordpress.theme.env`

> [!CAUTION]
> If you change `WORDPRESS_INSTALL_DIR` and `VUE_ROOT_DIR`, you need to reconfigure `docker/nginx/default.development.conf`.
> By default, the reverse proxy is set up to link to the wordpress container when access is made to `http://localhost/wp`, and the same goes for the vue container. There are also places in the `Dockerfile` and `docker-compose.yml` files where environment variables are used, and if the path is empty, etc., there will be a lot of slashes and an error may occur.
> If you want to modify it, you need to check the path settings of the wordpress install directory and volume mount directory settings, path settings in the env file, paths specified in docker-compose.yml, and other paths that affect the paths.

3.  Copy docker/php/wordpress.core.env.sample and rename it to wordpress.core.env

```
# Items that must be changed or set
# You can set the code that can be set in WordPress. Some of the language codes are listed in the .env file.
# @see [country code](https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/gettext.html#Country-Codes)
# @see (language code)[https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/gettext.html#Language-Codes]
WORDPRESS_CORE_DOWNLOAD_LOCALE
# The version can be specified by a number (8.0.0) or a character such as latest
WORDPRESS_CORE_DOWNLOAD_VERSION
Do not let WordPress install themes and plugins initially.
If true, nothing is installed.
If false, they will be installed.
WORDPRESS_CORE_DOWNLOAD_SKIP_CONTENT=true
```

4. run `make init` in terminal

```
$ make init
```

1. Access the server path you set up

[you can jump to the wordpress admin page](http://localhost/wp/wp-admin)