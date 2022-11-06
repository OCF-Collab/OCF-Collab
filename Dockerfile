FROM ruby:3.1.2

ENV APP_PATH /app/
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

RUN apt-get update -qqy && \
    apt-get install -y --no-install-recommends postgresql-client

RUN mkdir $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH

RUN bundle install

COPY . $APP_PATH

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
