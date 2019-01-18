FROM debian

EXPOSE 8000

WORKDIR /laravel-app

RUN apt-get update -y; \
		apt-get upgrade -y; \
		apt-get install wget git unzip gnupg -y;\
		apt-get install apt-transport-https lsb-release ca-certificates -y; \
		wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg; \
		echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list; \
		apt-get update -y; \
		apt-get install php7.3 -y; \
		apt-get install php7.3-xml -y; \
		apt-get install php7.3-zip -y; \
		apt-get install php7.3-mbstring -y; \
		apt-get install ca-certificates -y;
