FROM debian

WORKDIR	/react-app

EXPOSE 3000

RUN apt-get update -y; \
	apt-get upgrade -y; \
	apt-get install -y curl gnupg; \
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	apt-get install -y npm; \
	npm install -g yarn; \
	npm i -g npx; \

# docker run -it --mount type=bind,source="$(pwd)",target=/react-app -w /react-app -p 3001:3000 react sh -c "npx create-react-app my-app && cd my-app && yarn start"
# L'app est accessible sur $(docker-machine ip Char):3001
