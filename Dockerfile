FROM ruby:2.5.9

RUN apt update
RUN apt install nodejs -q -y

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

WORKDIR $INSTALL_PATH
COPY . .
RUN gem install bundler
# RUN gem install rails
# RUN bundle install
# CMD ["/bin/sh"]
CMD rails s -b 0.0.0.0 -p 3000