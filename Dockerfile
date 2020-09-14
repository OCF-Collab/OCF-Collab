FROM ruby:2.7.1

ENV APP_PATH /app/
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list  \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get update -qqy \
    && apt-get install -y --no-install-recommends nodejs yarn postgresql-client

RUN mkdir $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH
COPY package.json $APP_PATH
COPY yarn.lock $APP_PATH

COPY . $APP_PATH

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
