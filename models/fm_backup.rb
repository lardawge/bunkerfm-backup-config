# encoding: utf-8

##
# Backup Generated: fm_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t fm_backup [-c <path_to_configuration_file>]
#
Backup::Model.new(:fm_backup, 'filemaker database to s3') do
  archive :my_archive do |archive|
    archive.add '/Volumes/Macintosh HD2/filemaker_backups/progressive/Copies_FMS/'
  end

  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250

  ##
  # Amazon Simple Storage Service [Storage]
  #
  # Available Regions:
  #
  #  - ap-northeast-1
  #  - ap-southeast-1
  #  - eu-west-1
  #  - us-east-1
  #  - us-west-1
  #
  store_with S3 do |s3|
    s3.region            = "us-west-1"
    s3.bucket            = "bunker-backups"
    s3.path              = "filemaker_dbs"
    s3.keep              = 20
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = ENV["MAIL_FROM"]
    mail.to                   = ENV["MAIL_TO"]
    mail.address              = "smtp.gmail.com"
    mail.port                 = 587
    mail.domain               = ENV["MAIL_DOMAIN"]
    mail.user_name            = ENV["MAIL_USERNAME"]
    mail.password             = ENV["MAIL_PW"]
    mail.authentication       = "plain"
    mail.enable_starttls_auto = true
  end

end
