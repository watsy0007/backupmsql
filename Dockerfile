FROM ruby:2.3

RUN apt-get update && apt-get -y install rsyslog

ADD Gemfile /tmp
WORKDIR /tmp
RUN bundle install

WORKDIR /app
ADD . /app
RUN crontab /app/crontabfile && cp /app/crontabfile /etc/crontab && touch /var/log/cron.log && chmod +x ./scripts/run.sh
RUN bundle install

CMD ["bash","/app/scripts/run.sh"]