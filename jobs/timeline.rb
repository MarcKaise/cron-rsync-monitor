MAX_DAYS_OVERDUE = -30
MAX_DAYS_AWAY = 30

rsync_log = "/home/mkaise/git/cron-rsync/log_rsync.txt"
config_file = File.dirname(File.expand_path(__FILE__)) + '/../timeline.yml'

# SCHEDULER.every '6h', :first_in => 0 do |job|
SCHEDULER.every '87s', :first_in => 0 do |job|

    # Generate timeline_data.yml
    hash = {"events"=>[]}
    date = 0
    if File.exist?(rsync_log)
        File.foreach(rsync_log) { |line|
            # Push history only when add/remove files at the other day.
            if not date.eql?(line.split[0])
                if line.include?("deleting ")
                    hash["events"].push({
                        "name"=>"Del "+File.basename(line.split[4]),
                        "date"=>line.split[0],
                        "background"=>"lightgreen"
                    })
                    date = line.split[0]
                elsif line.include?(" >f")
                    hash["events"].push({
                        "name"=>"Add "+File.basename(line.split[4]),
                        "date"=>line.split[0],
                        "background"=>"lightgreen"
                    })
                    date = line.split[0]
                elsif line.include?("error: ")
                    hash["events"].push({
                        "name"=>"Error",
                        "date"=>line.split[0],
                        "background"=>"red"
                    })
                    date = line.split[0]
                end
            end
        }
    end
    File.open(config_file, 'w') do |text|
        text.puts(hash.to_yaml)
    end

    # Parse yml and set to widget
    config = YAML::load(File.open(config_file))
    unless config["events"].nil?
        events =  Array.new
        today = Date.today
        no_event_today = true
        config["events"].each do |event|
        days_away = (Date.parse(event["date"]) - today).to_i
        if (days_away >= 0) && (days_away <= MAX_DAYS_AWAY) 
            events << {
            name: event["name"],
            date: event["date"],
            background: event["background"]
            }
        elsif (days_away < 0) && (days_away >= MAX_DAYS_OVERDUE)
            events << {
            name: event["name"],
            date: event["date"],
            background: event["background"],
            opacity: 0.5
            }
        end

        no_event_today = false if days_away == 0
        end

        if no_event_today
        events << {
            name: "TODAY",
            date: today.strftime('%a %d %b %Y'),
            background: "gold"
        }
        end

        send_event("a_timeline", {events: events})
    else
        puts "No events found :("
    end
end
