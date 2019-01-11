FROM ruby

ONBUILD EXPOSE 3000

ONBUILD COPY . /opt/app
ONBUILD WORKDIR /opt/app

ONBUILD RUN apt-get update -y && apt-get install -y nodejs
ONBUILD RUN gem install bundler 
ONBUILD RUN bundle install
ONBUILD RUN rails db:create
ONBUILD RUN rails db:migrate



# Tester que ca fonctionne :
 
# Creer un projet Ruby :  
# docker run -it --mount type=bind,source="$(pwd)",target=/root -w /root ruby /bin/bash -c "gem install rails && rails new blog"
# Aller dans le projet cree (ici "blog")
# Build le Dockerfile "fils" : 
# docker build --tag ft_rails:on-build --file ../Dockerfile .
# Build le Dockerfile "parent" : 
# docker build --tag ft_ruby --file ../Dockerfile-test .
# Et enfin run Docker et lancer le serveur : 
# docker run -it -p 3000:3000 ft_ruby
