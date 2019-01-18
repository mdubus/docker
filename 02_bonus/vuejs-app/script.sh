#!/bin/bash

rm -rf my-app
SCRIPT="
vue init webpack my-app && \
	cd my-app && \
	npm install && \
	export HOST=0.0.0.0 && \
	npm run dev
"

docker run -it \
	--mount type=bind,source="$(pwd)",target=/vuejs-app \
	-w /vuejs-app \
	-p 3001:8080 \
	vuejs \
	sh -c "$SCRIPT"
