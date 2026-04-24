FROM ruby:4.0.3@sha256:ebd9bbec4962e1ed9ae266b6dd89fe183a6f748ef71ddbfd76994e91f13f62ad AS builder

# Set the working directory to /build
WORKDIR /build

# Copy the source code into the image for building
COPY . .

RUN apt-get update && apt-get install -y default-libmysqlclient-dev

# Install Rails 
RUN gem install rails
RUN gem install bundler rails
RUN bundle install

EXPOSE 3040

FROM ruby:4.0.3-slim@sha256:198547d3216e0efe6fb337997f22fa98eef4270b38033a697dad148d9d8b9b0d

RUN apt-get update && apt-get install -y default-libmysqlclient-dev

WORKDIR /
COPY --from=builder /build .
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Run the app
CMD [ "rails", "server", "-p", "3040", "-b", "0.0.0.0" ]
