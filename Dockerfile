FROM ruby:3.2.6

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get update && apt-get install -y vim && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
  libvips \
  imagemagick \
  libmagickwand-dev \
  && rm -rf /var/lib/apt/lists/*

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
