FROM ruby:2.4

ONBUILD EXPOSE 3000

ONBUILD COPY . /opt/app
ONBUILD WORKDIR /opt/app

ONBUILD RUN apt-get update -y && apt-get install -y nodejs
ONBUILD RUN gem install bundler
ONBUILD RUN bundle install
ONBUILD RUN rails db:create
ONBUILD RUN rails db:migrate



# Tester que ca fonctionne :
#./create_rails_project
# Build le Dockerfile "fils" : 
# docker build --tag ft_rails:on-build --file Dockerfile blog
# Build le Dockerfile "parent" : 
# docker build --tag ft_ruby --file Dockerfile-test blog
# Et enfin run Docker et lancer le serveur : 
# docker run -it -p 3000:3000 ft_ruby
