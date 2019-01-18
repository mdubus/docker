FROM debian

WORKDIR /vuejs-app

EXPOSE 8080

RUN apt-get update -y; \
	apt-get upgrade -y; \
	apt-get install -y curl gnupg; \
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	apt-get install -y npm; \
	npm install -g vue-cli;

# docker build --tag vuejs .
# ./script.sh
