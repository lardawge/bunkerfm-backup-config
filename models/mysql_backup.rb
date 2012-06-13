# encoding: utf-8

##
# Backup Generated: mysql_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t mysql_backup [-c <path_to_configuration_file>]
#
Backup::Model.new(:mysql_backup, 'mysql database to s3') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "bunker_production"
    db.username           = "rails"
    db.password           = ENV["MYSQL_PASSWORD"]
    db.host               = "localhost"
    db.port               = 3306
    db.additional_options = ["--quick", "--single-transaction"]
    # Optional: Use to set the location of this utility
    #   if it cannot be found by name in your $PATH
    db.mysqldump_utility = "/usr/bin/mysqldump"
  end

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
    s3.path              = "mysql_dbs"
    s3.keep              = 20
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  notify_by Mail do |mail|
    mail.on_success           = false
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
