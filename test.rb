require 'yaml'

# config_file = '/home/mkaise/git/demo-smashing/nas-backup-monitor/timeline_data.yml'

# config = YAML.load_file(config_file)

# p config["events"][0]["name"]

# config["events"][0]["name"] = "Code Fix"

# p config["events"][0]["name"]
# config.store("events[0].=>[{"name")


filename = "/home/mkaise/git/demo-rsync/log_rsync.txt"
hash = {"events"=>[]}

if File.exist?(filename)
    File.foreach(filename) { |line|
        if line.include?("deleting ")
            hash["events"].push({
                "name"=>"Del "+line.split[4],
                "date"=>line.split[0],
                "background"=>"white"
            })
        elsif line.include?(" >f")
            hash["events"].push({
                "name"=>"Add "+line.split[4],
                "date"=>line.split[0],
                "background"=>"lightgreen"
            })
        elsif line.include?("error: ")
            hash["events"].push({
                "name"=>"Error",
                "date"=>line.split[0],
                "background"=>"red"
            })
        end
    }
end

File.open('mkaise.yml', 'w') do |text|
    text.puts(hash.to_yaml)
end