FROM debian

WORKDIR	/django

EXPOSE 8000

RUN	apt-get update -y; \
	apt-get upgrade -y; \
	apt-get install -y python3-pip; \
	pip3 install django

# docker build --tag django .
# ./script.sh
