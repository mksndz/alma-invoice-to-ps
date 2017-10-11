require 'slack-notifier'
class NotificationService
  def initialize(slack_url)
    @slack = Slack::Notifier.new slack_url
  end

  def info(message)
    @slack.ping message
  end

  def error(message)
    @slack.ping "#{message}"
  end
end