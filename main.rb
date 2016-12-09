#!/usr/bin/env ruby
require_relative './cloud'

class Backup
  def initialize
    path_file = "./backups/#{Time.now.strftime('%Y%m%d')}.#{ENV['BACKUP_DB_NAME']}.sql.gz"
    `rm -f #{path_file}`

    pipe = IO.popen('./scripts/backup.sh')
    pipe.readlines.each { |e| $logger.info e }

    cloud = Cloud.new
    cloud.upload path_file
    unless `rm -rf #{path_file}`
      logger "dump #{path_file} error"
      exit(1)
    end

    logger "dump #{path_file} success"
  end

  def logger(msg)
    $logger.info "#{Time.now}: #{msg}"
  end
end

