FROM debian

LABEL maintainer="mdubus@student.42.fr"

ARG url=https://files.teamspeak-services.com/releases/server/3.5.1/teamspeak3-server_linux_amd64-3.5.1.tar.bz2
ARG	filename=teamspeak.tar.bz2
ARG tsdirectory=teamspeak

EXPOSE 9987/udp
WORKDIR /teamspeak

RUN apt-get update; \
	apt-get install -y wget bzip2; \
	wget -P . -O $filename "$url"; \
	mkdir $tsdirectory; \
	tar -xjvf $filename -C $tsdirectory --strip-components 1; \
	cd $tsdirectory; \
	touch .ts3server_license_accepted;

CMD ./teamspeak/ts3server_minimal_runscript.sh

# Pour tester : 
# docker run -t -p 9987:9987/udp <PID du container>
# Installer TS via le MSC et mettre en server adress l'IP de Char. Osef du reste. 
