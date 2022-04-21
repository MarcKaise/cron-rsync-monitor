# set path of log file
filename = "/home/mkaise/git/demo-rsync/log_result.txt"
logs = Hash.new({ value: 0 })

def tail(filename,line,readLength)
    ary=[]
    f=File.open(filename)
    begin
      f.seek(-readLength,IO::SEEK_END)
    rescue
  end
    while f.gets
      ary<<$_
    end
    f.close
    return ary[ary.length-line]
  end


SCHEDULER.every '2s' do
    for i in 0..20
        logs[i] = { label: tail(filename, i, 100 * 1024) }
    end
    send_event('rsync_history', { items: logs.values })
end