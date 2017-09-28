require "tomato/version"
require "tomato/cli"
require "tomato/notifier"
require "tomato/pomodoro"
require "tomato/custom_pomodoro"
require "tomato/slack_session"
require "tomato/log"

require "yaml"
require "ostruct"

module Tomato
  class << self
    def config
      @config ||= OpenStruct.new(YAML.load_file(config_path))
    end

    def config_path
      File.expand_path("~/.tomato.yml")
    end
  end
end
