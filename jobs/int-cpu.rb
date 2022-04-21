require 'sys/filesystem'

storage_path = "/"

SCHEDULER.every '2s' do

    metervalue = `vmstat | tail -n 1 | awk '{print (100 - $15)}'`   # cpu usage
    metervalue2 = `free -m | sed -n 2p | awk '{printf("%d\\n",$3 / $2 * 100)}'` # memory usage
    metervalue3 = Sys::Filesystem.stat(storage_path).percent_used.round # USB HDD
    metervalue4 = rand(100)
    metervalue6 = rand(100)
    metervalue7 = rand(100)

    servers = Array.new
    servers << {name: "CPU", progress: metervalue}
    servers << {name: "MEM", progress: metervalue2}
    servers << {name: "HDD", progress: metervalue3}
    # servers << {name: "EXCHANGE", progress: metervalue4}
    # servers << {name: "SUBVERSION", progress: metervalue6}
    # servers << {name: "VNODE 1", progress: metervalue7}

    send_event('pbar', {title: "Resource Usage", progress_items: servers})
end
