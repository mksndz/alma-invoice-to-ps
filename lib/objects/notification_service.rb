class NotificationService
  def initialize(slack_url)
    @slack = Slack::Notifier slack_url
  end

  def info(message)
    @slack.ping message
  end

  def error(message)
    @slack.ping "#{message}, do something someone! @here"
  end
end