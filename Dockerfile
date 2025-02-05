FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set working directory
WORKDIR /app

# Copy the Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the app
COPY . .

# Expose the Rails port
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]