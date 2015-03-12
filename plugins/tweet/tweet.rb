require 'twitter'

class Tweet
  include Cinch::Plugin

  listen_to :connect, method: :connected

  def connected(_)
    @twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = @bot.bot_config['twitter']['consumer_key']
      config.consumer_secret = @bot.bot_config['twitter']['consumer_secret']
      config.access_token = @bot.bot_config['twitter']['access_key']
      config.access_token_secret = @bot.bot_config['twitter']['access_secret']
    end
  end


  match /.*(https:\/\/twitter.com\/[^\/]+\/status\/[^\/]+)/, :use_prefix => false

  def execute(m, uri)
    status = @twitter.status(URI(uri))
    text = status.full_text
    user = status.user.screen_name
    m.reply "@#{user}: #{text}"
  end
end