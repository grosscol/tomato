require "thor"

module Tomato

  class CLI < Thor

    option :work, default: 25, type: :numeric, aliases: "-w",
      banner: "Minutes to work"
    option :rest, default: 5, type: :numeric, aliases: "-r",
      banner: "Minutes to rest"
    option :ambiance, type: :string, aliases: "-a",
      banner: "Sound to play while working, specified in config"
    desc "start [options] SUBJECT", "Start a tomato with SUBJECT"
    def start(subject)
      tomato = CustomPomodoro.new(
        Pomodoro.new(subject, options[:work], options[:rest]),
        Ambiance.new(config.ambiance[options[:ambiance]])
      )


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
      if File.exist?(Tomato.config_path)
        puts "A config file exists at #{Tomato.config_path}, exiting"
      else
        puts "Installing #{Tomato.config_path} with sensible defaults."
        puts "You'll want to change these if not on ubuntu."
        puts "And add slack api keys"
        content = YAML.dump({
          "slack" => [],
          "log_path" => File.expand_path("~/.tomato.log"),
          "work_sound" => "/usr/share/sounds/ubuntu/stereo/desktop-logout.ogg",
          "rest_sound" => "/usr/share/sounds/ubuntu/stereo/system-ready.ogg",
          "ambiance"   => {}
        })
        File.write(Tomato.config_path, content)
      end
    end

    private
    def config
      Tomato.config
    end

  end

end

