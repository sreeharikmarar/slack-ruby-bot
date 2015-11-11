module SlackRubyBot
  class App < Server
    include SlackRubyBot::Hooks::Hello

    def initialize
      SlackRubyBot.configure do |config|
        config.token = ENV['SLACK_API_TOKEN'] || fail("Missing ENV['SLACK_API_TOKEN'].")
        config.aliases = ENV['SLACK_RUBY_BOT_ALIASES'].split(' ') if ENV['SLACK_RUBY_BOT_ALIASES']
      end
      Slack.configure do |config|
        config.token = SlackRubyBot.config.token
      end
    end

    def config
      SlackRubyBot.config
    end

    def self.instance
      @instance ||= SlackRubyBot::App.new
    end

    private

    def auth!
      super
      SlackRubyBot.configure do |config|
        config.url = auth['url']
        config.team = auth['team']
        config.user = auth['user']
        config.team_id = auth['team_id']
        config.user_id = auth['user_id']
      end
    end

    def reset!
      super
      SlackRubyBot.configure do |config|
        config.url = nil
        config.team = nil
        config.user = nil
        config.team_id = nil
        config.user_id = nil
      end
    end
  end
end
