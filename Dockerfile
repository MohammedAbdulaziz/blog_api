FROM ruby:3.3.4

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

CMD ["bash"]
