FROM	ubuntu

EXPOSE	443 80 22

RUN		apt-get update -y && apt-get upgrade -y
RUN		apt-get install -y curl openssh-server ca-certificates
RUN		curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash
RUN		apt-get install -y --no-install-recommends gitlab-ce tzdata

RUN		mkdir -p /etc/gitlab/ssl && \
		chmod 700 /etc/gitlab/ssl

RUN		mkdir -p /etc/gitlab/ssl && \
		chmod 700 /etc/gitlab/ssl

RUN		openssl genrsa -out /etc/gitlab/ssl/gitlab.example.com.key 2048 && \
		openssl req -new -x509 -key /etc/gitlab/ssl/gitlab.example.com.key \
		-out /etc/gitlab/ssl/gitlab.example.com.crt -days 3650 -subj /CN=gitlab.example.com

RUN	echo "letsencrypt['enable'] = false" >> /etc/gitlab/gitlab.rb && \
	echo "external_url \"https://gitlab.example.com\"" >> /etc/gitlab/gitlab.rb && \
	echo "nginx['redirect_http_to_https'] = true" >> /etc/gitlab/gitlab.rb && \
	echo "nginx['ssl_certificate'] = \"/etc/gitlab/ssl/gitlab.example.com.crt\"" >> /etc/gitlab/gitlab.rb && \
	echo "nginx['ssl_certificate_key'] = \"/etc/gitlab/ssl/gitlab.example.com.key\"" >> /etc/gitlab/gitlab.rb && \
	echo "gitlab_rails['gitlab_shell_ssh_port'] = 22" >> /etc/gitlab/gitlab.rb

ENTRYPOINT	service ssh start && (/opt/gitlab/embedded/bin/runsvdir-start &) && \
			(gitlab-ctl reconfigure &) && \
			tail -F /dev/null





