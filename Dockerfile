FROM ruby:2.3.0
MAINTAINER Sebastian Schkudlara "sebastian.schkudlara@vizzuality.com"

RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy postgresql-client libpq-dev libxml2-dev libxslt1-dev

RUN mkdir /rw_tags

WORKDIR /rw_tags
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /rw_tags

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3025

ENTRYPOINT ["./entrypoint.sh"]
