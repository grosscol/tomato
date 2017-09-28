module Tomato

  class CustomPomodoro

    def initialize(pomodoro, notifier = Notifier.new)
      @pomo = pomodoro
      @notifier = notifier
    end

    def start
      build
      pomo.start
    end

    def cancel
      slack_sessions.each {|s| s.end }
    end

    private
    attr_reader :pomo, :notifier

    def config
      Tomato.config
    end

    def slack_sessions
      @slack_sessions ||= config.slack.map do |token|
        SlackSession.new(token, pomo.work_time)
      end
    end

    def build
      slack_sessions.each do |slack_session|
        pomo.add_before_start { slack_session.start }
        pomo.add_after_work { slack_session.end }
      end

      pomo.add_after_work {
        notifier.notify("pomo complete, time to rest", config.work_sound)
      }

      pomo.add_after_rest {
        notifier.notify("Rest complete, get back to work", config.rest_sound)
      }

      now = Time.now
      pomo.add_after_work { Log.new(config.log_path).append(now, pomo.subject) }
    end

  end

end
