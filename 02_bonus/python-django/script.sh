#!/bin/bash
rm -rf myapp
SCRIPT="
django-admin startproject myapp && \
	cd myapp && \
	python3 manage.py migrate && \
	sed -i '/^ALLOWED_HOSTS/s/\[\]/\[\"*\"\]/' myapp/settings.py && \
	python3 manage.py runserver 0.0.0.0:8000
"

docker run 	-it \
	--mount type=bind,source="$(pwd)",target=/django \
	-w /django \
	-p 8000:8000 \
	django \
	sh -c "$SCRIPT"
