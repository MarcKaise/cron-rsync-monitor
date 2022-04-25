# set path of log file
filename = "/home/mkaise/git/cron-rsync/log_cron.txt"

SCHEDULER.every '55s' do
    # judge backup status 
    if File.exist?( filename )
        lines = File.readlines( filename ).grep(/failed/)
        if lines.empty?
            # msg = "no failure observed."
            msg = File.readlines( filename ).last
            result = "ok"
        else
            msg = lines.first
            result = "critical"
        end
    else
        msg = "log file not found."
        result = "warning"
    end

    # update dashboard
    send_event('hotstat', { message: msg, status: result })
end