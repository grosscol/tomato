require "json"
require "uri"

module Tomato

  class SlackSession

    SLACK_URL = "https://slack.com/api"

    def initialize(token, duration)
      @token = token
      @duration = duration
      @started = false
    end

    # Sets your Do Not Disturb status
    def start
      return if started
      @started = Time.now
      start_dnd
    end

    def end
      end_dnd
    end

    private
    attr_reader :token, :duration
    attr_accessor :started

    def start_dnd
      slack_send("dnd.setSnooze", {num_minutes: duration})
      slack_send("users.profile.set", {
        profile: {
          status_text: dnd_message,
          status_emoji: ":timer_clock:"
        }
      })
    end

    def end_dnd
      slack_send("dnd.endDnd", {})
      slack_send("users.profile.set", {
        profile: {
          status_text: "",
          status_emoji: ""
        }
      })
    end

    def slack_send(endpoint, args)
      request_url = File.join SLACK_URL, endpoint
      query_string = args.map do |key,value|
        if value.is_a? Hash
          "#{key}=#{URI.encode(JSON.dump(value))}"
        else
          "#{key}=#{value}"
        end
      end
      query_string << "token=#{token}"
      cmd = "curl '#{request_url}?#{query_string.join("&")}' > /dev/null 2>&1"
      system(cmd)
    end

    def dnd_message
      "I will return at #{end_time.strftime("%l:%M%P")} #{Time.now.zone}"
    end

    def end_time
      started + (duration * 60) # add seconds
    end

  end

end
