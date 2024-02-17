FROM ruby:3.0.3

WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN bundle install -j 8

ADD . .
