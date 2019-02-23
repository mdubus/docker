#!/bin/bash
rm -rf my-app
rm composer.phar
SCRIPT="
    php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\" && \
	php -r \"if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\" && \
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
