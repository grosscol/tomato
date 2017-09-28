require "thor"

module Tomato

  class CLI < Thor
    option :work, default: 25, type: :numeric, aliases: "-w",
      banner: "Minutes to work"
    option :rest, default: 5, type: :numeric, aliases: "-r",
      banner: "Minutes to rest"
    desc "start [options] SUBJECT", "Start a tomato with SUBJECT"
    def start(subject)
      tomato = CustomPomodoro.new(Pomodoro.new(subject, options[:work], options[:rest]))
      Signal.trap("INT") do
        tomato.cancel
        exit
      end
      tomato.start
    end

    desc "log", "Show log of completed tomatos"
    def log
      puts Log.new(config.log_path).to_s
    end

    desc "install", "Create an empty config"
    def install
      puts "Installing #{Tomato.config_path} with sensible defaults."
      puts "You'll want to change these if not on ubuntu."
      puts "And add slack api keys"
      content = YAML.dump({
        "slack" => [],
        "log_path" => File.expand_path("~/.tomato.log"),
        "work_sound" => "/usr/share/sounds/ubuntu/stereo/desktop-logout.ogg",
        "rest_sound" => "/usr/share/sounds/ubuntu/stereo/system-ready.ogg"
      })
      File.write(Tomato.config_path, content)
    end

    private
    def config
      Tomato.config
    end

  end

end

