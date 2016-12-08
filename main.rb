#!/usr/bin/env ruby
require_relative './cloud'
require 'logger'

class Backup
  attr_accessor :log
  def initialize
    path_file = "./backups/#{Time.now.strftime('%Y%m%d')}.#{ENV['BACKUP_DB_NAME']}.sql.gz"
    `rm -f #{path_file}`

    unless `./scripts/backup.sh`
      logger 'backup error, please check'
      exit 1
    end

    cloud = Cloud.new method(:logger)
    cloud.upload path_file
    unless `rm -rf #{path_file}`
      logger "dump #{path_file} error"
      exit(1)
    end

    logger "dump #{path_file} success"
  end

  def logger(msg)
    @log ||= Logger.new(STDOUT)
    @log.info "#{Time.now}: #{msg}"
  end
end

Backup.new
