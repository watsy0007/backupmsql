scheduler = Rufus::Scheduler.singleton

require_relative './main'
scheduler.cron '00 30 * * *' do
  $logger.info 'start backup'
  Backup.new
end
