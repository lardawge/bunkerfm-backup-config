# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "~/Backup/log/cron.log"
 
every 1.hours do
  command "backup perform -t fm_backup"
end

# Learn more: http://github.com/javan/whenever
