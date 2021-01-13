FROM ruby:2.7.2

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

COPY . /usr/src/myapp

RUN bundle install
RUN bin/rails webpacker:install

# run the app with a default command
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
