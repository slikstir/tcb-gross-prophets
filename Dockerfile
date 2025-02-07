FROM ruby:3.2.6

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

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

CMD ["rdbg", "--open", "--port", "12345", "--host", "0.0.0.0", "-- bin/rails", "server", "-b", "0.0.0.0"]
