# first step:
rewrite to .env

```.env
--- WORDPRESS_DEVELOP_MODE=

+++ WORDPRESS_DEVELOP_MODE=plugin
```

# second step:

copy `docker/php/wordpress.plugin.env.sample` to `docker/php/wordpress.plugin.env`

# third step:

Set options for plugin development in wordpress.plugin.env

# Generate Plugin Directory

The following files are always generated:
- plugin-slug.php is the main PHP plugin file.
- readme.txt is the readme file for the plugin.
- package.json needed by NPM holds various metadata relevant to the project. Packages: grunt, grunt-wp-i18n and grunt-wp-readme-to-markdown. Scripts: start, readme, i18n.
- Gruntfile.js is the JS file containing Grunt tasks. Tasks: i18n containing addtextdomain and makepot, readme containing wp_readme_to_markdown.
- .editorconfig is the configuration file for Editor.
- .gitignore tells which files (or patterns) git should ignore.
- .distignore tells which files and folders should be ignored in distribution.

The following files are also included unless the --skip-tests is used:
- phpunit.xml.dist is the configuration file for PHPUnit.
- .travis.yml is the configuration file for Travis CI. Use --ci=&lt;provider&gt; to select a different service.
- bin/install-wp-tests.sh configures the WordPress test suite and a test database.
- tests/bootstrap.php is the file that makes the current plugin active when running the test suite.
- tests/test-sample.php is a sample file containing test cases.
- .phpcs.xml.dist is a collection of PHP_CodeSniffer rules.