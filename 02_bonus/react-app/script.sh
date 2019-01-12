#!/bin/bash
rm -rf myapp
SCRIPT="
npx create-react-app my-app && \
	cd my-app && \
	yarn start
"

docker run -it \
	--mount type=bind,source="$(pwd)",target=/react-app \
	-w /react-app \
	-p 3001:3000 \
	react \
	sh -c "$SCRIPT"
