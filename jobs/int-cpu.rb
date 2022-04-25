require 'sys/filesystem'

SCHEDULER.every '63s' do

    metervalue = `vmstat | tail -n 1 | awk '{print (100 - $15)}'`   # cpu usage
    metervalue2 = Sys::Filesystem.stat("/").percent_used.round # ROM usage
    metervalue3 = `free -m | sed -n 2p | awk '{printf("%d\\n",$3 / $2 * 100)}'` # RAM usage
    metervalue4 = Sys::Filesystem.stat("/mnt/nas").percent_used.round # NAS SSD usage
    metervalue6 = Sys::Filesystem.stat("/mnt/backup").percent_used.round # Backup HDD usage
    metervalue7 = rand(100)

    servers = Array.new
    servers << {name: "CPU", progress: metervalue}
    servers << {name: "ROM", progress: metervalue2}
    servers << {name: "RAM", progress: metervalue3}
    servers << {name: "NAS", progress: metervalue4}
    servers << {name: "BCK", progress: metervalue6}
    # servers << {name: "VNODE 1", progress: metervalue7}

    send_event('pbar', {title: "Resource Usage", progress_items: servers})
end
