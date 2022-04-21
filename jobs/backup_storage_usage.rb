require 'sys/filesystem'

storage_path = "/"

SCHEDULER.every '10s' do
    stat = Sys::Filesystem.stat( storage_path )
    send_event('backup_storage_usage',  { value: stat.percent_used.round })
end