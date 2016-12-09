FROM ruby:2.3

RUN apt-get update && apt-get -y install rsyslog cron

ADD Gemfile /tmp
ADD Gemfile.lock /tmp
WORKDIR /tmp
RUN bundle install

WORKDIR /app
ADD . /app
RUN crontab /app/crontabfile && touch /var/log/cron.log && cp -rf ./config/.profile /root/.profile && chmod +x ./scripts/run.sh

CMD ["bash","/app/scripts/run.sh"]