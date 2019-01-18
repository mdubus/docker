#!/bin/bash
rm -rf my-app
rm composer.phar
SCRIPT="
    php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\" && \
	php -r \"if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\" && \
	php composer-setup.php && \
	php -r \"unlink('composer-setup.php');\" && \
	mv composer.phar /usr/local/bin/composer && \
	composer create-project symfony/skeleton my-app && \
	cd my-app && \
	composer require server --dev && \
	php bin/console server:run 0.0.0.0:8000
"

docker run -it \
	--mount type=bind,source="$(pwd)",target=/symfony-app \
	-w /symfony-app \
	-p 8000:8000 \
	symfony \
	sh -c "$SCRIPT"
