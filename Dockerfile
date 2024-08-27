# Use an official Ruby runtime as a parent image
FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the application code
COPY . .

# Set the environment to development
ENV RAILS_ENV development

# Precompile assets for production (optional for development)
# RUN bundle exec rake assets:precompile

# Expose the port that the Rails app will run on
EXPOSE 3000