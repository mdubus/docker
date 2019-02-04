FROM debian:sid

RUN		apt-get update -y && \
		apt-get upgrade -y && \
		apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libre2-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate rsync python-docutils pkg-config cmake && \
		apt-get update -y && \
		apt-get install -y git ruby ruby-dev golang nodejs yarnpkg && \
		gem install bundler --no-document && \
		adduser --disabled-login --gecos 'mdubus' git

# Database
RUN		apt-get install -y postgresql postgresql-client libpq-dev postgresql-contrib && \
		service postgresql start && \
		runuser -u postgres -- psql -d template1 -c "CREATE USER git CREATEDB;" && \
		runuser -u postgres -- psql -d template1 -c "ALTER USER git WITH PASSWORD 'password';" && \
		runuser -u postgres -- psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;" && \
		runuser -u postgres -- psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER git;" && \
		runuser -u git -- psql -d gitlabhq_production -c "SELECT true AS enabled FROM pg_available_extensions WHERE name = 'pg_trgm' AND installed_version IS NOT NULL;" | grep --quiet enabled

# Redis
RUN		apt-get install -y redis-server && \
		cp /etc/redis/redis.conf /etc/redis/redis.conf.orig && \
		sed 's/^port .*/port 0/' /etc/redis/redis.conf.orig | tee /etc/redis/redis.conf && \
		echo 'unixsocket /var/run/redis/redis.sock' >> /etc/redis/redis.conf && \
		echo 'unixsocketperm 770' >> /etc/redis/redis.conf && \
		mkdir /var/run/redis && \
		chown redis:redis /var/run/redis && \
		chmod 755 /var/run/redis && \
		if [ -d /etc/tmpfiles.d ]; then echo 'd  /var/run/redis  0755  redis  redis  10d  -' | tee -a /etc/tmpfiles.d/redis.conf; fi && \
		service redis-server restart && \
		usermod -aG redis git

# gitlab
RUN		cd /home/git && \
		runuser -u git -- git clone --depth=1  https://gitlab.com/gitlab-org/gitlab-ce.git -b 11-7-stable gitlab && \
		cd /home/git/gitlab && \
		runuser -u git -- cp config/gitlab.yml.example config/gitlab.yml && \
		sed -i '/port: 80/s/80/443/g' config/gitlab.yml && \
		sed -i '/https: false/s/false/true/g' config/gitlab.yml && \
		sed -i '/email_from:/s/example@example.com/gitlab@localhost/g' config/gitlab.yml && \
		runuser git -c "cp config/secrets.yml.example config/secrets.yml && \
						chmod 0600 config/secrets.yml && \
						chown -R git log/ && \
						chown -R git tmp/ && \
						chmod -R u+rwX,go-w log/ && \
						chmod -R u+rwX tmp/ && \
						mkdir public/uploads/ && \
						chmod 0700 public/uploads && \
						chmod -R u+rwX builds/ && \
						chmod -R u+rwX shared/artifacts/ && \
						chmod -R ug+rwX shared/pages/ && \
						cp config/unicorn.rb.example config/unicorn.rb && \
						nproc && \
						cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb && \
						git config --global core.autocrlf input && \
						git config --global gc.auto 0 && \
						git config --global repack.writeBitmaps true && \
						git config --global receive.advertisePushOptions true && \
						cp config/resque.yml.example config/resque.yml"

WORKDIR /home/git/gitlab

# DB settings && Install Gems && Gitlab Shell && Gitlab Workhouse
RUN		gem update --system && \
		runuser git -c "cp config/database.yml.postgresql config/database.yml && \
		sed -i '/password:/s/secure password/password/' config/database.yml && \
		chmod o-rwx config/database.yml && \
		bundle install --deployment --without development test mysql aws kerberos && \
		bundle exec rake gitlab:shell:install REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production SKIP_STORAGE_VALIDATION=true && \
		bundle exec rake 'gitlab:workhorse:install[/home/git/gitlab-workhorse]' RAILS_ENV=production"

# Install Gitaly
RUN		runuser -u git -- bundle exec rake 'gitlab:gitaly:install[/home/git/gitaly,/home/git/repositories]' RAILS_ENV=production && \
		chmod 0700 /home/git/gitlab/tmp/sockets/private && \
		chown git /home/git/gitlab/tmp/sockets/private

# Initialize Database and Activate Advanced Features
RUN		service postgresql start && \
		sed -i "/^bin_dir/s|/bin||" ../gitaly/config.toml && \
		sed -i "/^client_path/s|/bin||" config/gitlab.yml && \
		sed -i '4d' lib/tasks/gitlab/setup.rake && \
		runuser -u git -- bundle exec rake gitlab:setup RAILS_ENV=production force=yes GITLAB_ROOT_PASSWORD="password" GITLAB_ROOT_EMAIL=admin@localhost

# Install Init Script / Logrotage / Compile GetText PO files / Compile Assets
RUN		service postgresql start && \
		cp lib/support/init.d/gitlab /etc/init.d/gitlab && \
		update-rc.d gitlab defaults 21 && \
		cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab && \
		apt-get install -y npm && \
		npm install -g yarn

RUN		service postgresql start && \
		runuser -u git -- bundle exec rake gettext:compile RAILS_ENV=production

RUN		service postgresql start && \
		runuser -u git -- yarn install --production --pure-lockfile

RUN		service postgresql start && \
		runuser -u git -- bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production
# docker build --tag gitlab .
# docker run -it gitlab
