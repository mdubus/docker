FROM debian

WORKDIR	/symfony-app

EXPOSE 8000

RUN apt-get update -y; \
	apt-get upgrade -y; \
	apt-get install php7.0 -y; \
	apt-get install php7.0-xml -y; \
	apt-get install git -y; \
	apt-get install ca-certificates -y; 

# docker build --tag symfony .
# ./script.sh
