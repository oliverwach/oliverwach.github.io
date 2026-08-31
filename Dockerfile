# Base image: Ruby with necessary dependencies for Jekyll
FROM ruby:3.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*


# Create a non-root user with UID 1000
RUN groupadd -g 1000 vscode && \
    useradd -m -u 1000 -g vscode vscode

# Set the working directory
WORKDIR /usr/src/app

# Set permissions for the working directory
RUN chown -R vscode:vscode /usr/src/app

# Switch to the non-root user
USER vscode

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Copy package.json and package-lock.json for Node dependencies
COPY package.json package-lock.json ./

# Install Ruby dependencies using bundler (don't install bundler explicitly - use Ruby 3.2 built-in)
RUN bundle install

# Install Node dependencies
RUN npm install

# Build minified JavaScript
RUN npm run build:js

# Command to serve the Jekyll site
CMD ["jekyll", "serve", "-H", "0.0.0.0", "-w", "--config", "_config.yml,_config_docker.yml"]
