require "pathname"

module Tomato

  class Ambiance
    def initialize(path)
      @path = Pathname.new(path.to_s)
    end

    def start
      return unless path.exist?
      @pid = Process.spawn("#{player} #{path}", out: "/dev/null", err: "/dev/null")
    end

    def stop
      return if pid.nil?
      system("kill #{pid} > /dev/null 2>&1")
    end


    private
    attr_reader :path, :pid

    def player
      case path.extname
      when ".mp3", ".mpg"
        "mpg123"
      when ".ogg"
        "paplay"
      end
    end
  end

end
