module Tomato

  class CustomPomodoro

    def initialize(pomodoro, ambiance, notifier = Notifier.new)
      @pomo = pomodoro
      @ambiance = ambiance
      @notifier = notifier
    end

    def start
      build
      pomo.start
    end

    def cancel
      slack_sessions.each {|s| s.end }
      ambiance.stop
    end

    private
    attr_reader :pomo, :ambiance, :notifier

    def config
      Tomato.config
    end

    def slack_sessions
      @slack_sessions ||= config.slack.map do |token|
        SlackSession.new(token, pomo.work_time)
      end
    end


    def add_ambiance_hooks
      pomo.add_before_start { ambiance.start }
      pomo.add_after_work { ambiance.stop }
    end

    def add_slack_hooks
      slack_sessions.each do |slack_session|
        pomo.add_before_start { slack_session.start }
        pomo.add_after_work { slack_session.end }
      end
    end

    def add_notify_hooks
      pomo.add_after_work {
        notifier.notify("pomo complete, time to rest", config.work_sound)
      }

      pomo.add_after_rest {
        notifier.notify("Rest complete, get back to work", config.rest_sound)
      }
    end

    def add_log_hooks
      now = Time.now
      pomo.add_after_work { Log.new(config.log_path).append(now, pomo.subject) }
    end

    def build
      add_ambiance_hooks
      add_slack_hooks
      add_notify_hooks
      add_log_hooks
    end

  end

end
