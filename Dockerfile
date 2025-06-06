FROM ruby:3.4.2-slim

RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  apt-get update -qq && apt-get install -yq --no-install-recommends \
  build-essential \
  gnupg2 \
  git \
  nano \
  yarn \
  libyaml-dev \
  default-libmysqlclient-dev \ 
  libpq-dev \ 
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

WORKDIR /usr/src/app
COPY Gemfile /Gemfile
COPY Gemfile.lock /Gemfile.lock
COPY package.json yarn.lock /

RUN gem update --system && gem install bundler && bundle install
RUN yarn

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "/usr/bin/entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
