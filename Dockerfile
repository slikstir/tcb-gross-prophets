FROM ruby:3.2.6

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs
RUN apt-get update && apt-get install -y vim && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
  libvips \
  imagemagick \
  libmagickwand-dev \
  && rm -rf /var/lib/apt/lists/*

# Install dependencies and PostgreSQL 16 client
RUN apt-get update && \
    apt-get install -y wget gnupg2 lsb-release && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-16 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install debugging tools
RUN gem install debug pry-byebug

# Copy the Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the app
COPY . .

# Expose the Rails port
EXPOSE 3000 12345

# bundle exec shorthand
RUN echo 'alias be="bundle exec"' >> ~/.bashrc

ENV EDITOR=vim

CMD ["rdbg", "--open", "--port", "12345", "--host", "0.0.0.0", "-- bin/rails", "server", "-b", "0.0.0.0"]
