# -*- coding: utf-8 -*-
require 'qiniu'
class Cloud
  attr_accessor :bucket
  def initialize(logger = nil)
    Qiniu.establish_connection! access_key: ENV['QINIU_TOKEN'], secret_key: ENV['QINIU_KEY']
  end

  def upload(file_path)
    key = file_path.split('/')[-1]
    put_policy = Qiniu::Auth::PutPolicy.new bucket, key, 3600

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    code, result, _resp_headers = Qiniu::Storage.upload_with_token_2 uptoken, file_path, key, nil, bucket: bucket
    $logger.info "upload code:#{code}\tresult: #{result}"
  end

  def bucket
    @bucket ||= ENV['QINIU_BUCKET']
  end
end
