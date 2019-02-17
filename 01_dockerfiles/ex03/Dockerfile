FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ARG GITLAB_IP=localhost

# tzdata > https://gitlab.com/gitlab-org/omnibus-gitlab/issues/2229
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y curl openssh-server ca-certificates git tzdata

# Add GitLab repo
RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash

# Install GitLab package
RUN apt-get update -y && apt-get install -y --no-install-recommends gitlab-ce

# Create self-signed certificate
RUN mkdir -p /etc/gitlab/ssl && \
	chmod 700 /etc/gitlab/ssl && \
	openssl req -new -x509 -nodes -newkey rsa:2048 -keyout /etc/gitlab/ssl/gitlab.key -out /etc/gitlab/ssl/gitlab.crt -days 365 -subj /CN=${GITLAB_IP} && \
	sed -i -e "s|^\(external_url\) .*$|\1 'https://${GITLAB_IP}'|" \
	-e "s|^# \(nginx\['ssl_certificate'\] = \"/etc/gitlab/ssl\)/.*$|\1/gitlab.crt\"|" \
	-e "s|^# \(nginx\['ssl_certificate_key'\] = \"/etc/gitlab/ssl\)/.*$|\1/gitlab.key\"|" \
	-e "s|^# \(gitlab_rails\['gitlab_shell_ssh_port'\] = 22\)$|\1|" \
	/etc/gitlab/gitlab.rb

EXPOSE 443
EXPOSE 22

ENTRYPOINT  service ssh start && \
				(/opt/gitlab/embedded/bin/runsvdir-start &) && \
				gitlab-ctl reconfigure && \
				gitlab-ctl tail

# Build
# docker build --build-arg GITLAB_IP=(docker-machine ip Char) -t gitlab .
# Run
# docker run --rm -it -p 8000:443 -p 8022:22 --privileged gitlab
# Test
# open https://(docker-machine ip Char):8000
# Clone
# env GIT_SSL_NO_VERIFY=true git clone https://(docker-machine ip Char):8000/root/<repo>.git
