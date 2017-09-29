module Tomato

  class Ambiance
    def initialize(path)
      @path = path
    end

    def start
      return unless File.exist? path
      @pid = Process.spawn("#{player} #{path}", out: "/dev/null", err: "/dev/null")
    end

    def stop
      return if pid.nil?
      system("kill #{pid} > /dev/null 2>&1")
    end


    private
    attr_reader :path, :pid

    def player
      case File.extname path
      when ".mp3", ".mpg"
        "mpg123"
      when ".ogg"
        "paplay"
      end
    end
  end

end
