module Tomato

  class Notifier
    def notify(message, sound_path)
      send_notification(message)
      play_sound(sound_path)
    end

    private

    def send_notification(message)
      IO.popen("notify-send --urgency=normal 'Tomato' '#{message}'")
    end

    def play_sound(sound_path)
      IO.popen("paplay #{sound_path}")
    end
  end

end
