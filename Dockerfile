FROM ruby:2.5-alpine
ENV BIND=0.0.0.0 PORT=8000 USER=user PASS=pass MOCK=mock
COPY Gemfile /app/
COPY mock /app/mock
COPY lenovo-sr650 /app/lenovo-sr650
WORKDIR /app
RUN bundle

ENTRYPOINT \
  bundle exec redfish serve \
    --user $USER \
    --pass $PASS \
    --bind $BIND \
    --port $PORT \
    $MOCK
