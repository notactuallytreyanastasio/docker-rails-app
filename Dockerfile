FROM ruby:2.7.2
LABEL maintainer="bobby@quantierra.com"

# add repositories for apt for nodejs, yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
    tee /etc/apt/sources.list.d/yarn.list

# standard installs for our env, nodejs for js runtime, yarn for pkg mgmt/webpack,
# and vim for editing text in the container if needed
RUN apt-get update -yqq && apt-get install -yqq \
    nodejs \
    yarn \
    vim

WORKDIR /usr/src/myapp
COPY Gemfile* /usr/src/myapp/
ENV BUNDLE_PATH /gems
RUN bundle install

# note, that I have run bin/rails webpacker:install and included those files, so
# the COPY operation already copies those in, making it so we don't have to run
# that bootstrapping piece that is included in the book
# run the app with a default command
COPY . /usr/src/myapp/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
