module Tomato

  class Log
    def initialize(path)
      @path = File.expand_path(path)
    end

    def to_s
      `touch #{path}`
      File.read(path)
    end

    def append(time, subject)
      `touch #{path}`
      content = File.read(path) + "#{time.strftime("%Y-%m-%d %H:%M")} #{subject}\n"
      File.write(path, content)
    end

    private
    attr_reader :path

  end

end
