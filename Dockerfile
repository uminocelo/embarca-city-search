FROM ruby:2.7.8

RUN apt-get update && \
    apt-get install -y build-essential libpq-dev nodejs && \
    gem install rails -v 5.0

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

CMD ["rails", "server", "-b", "0.0.0.0"]
