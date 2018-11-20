# frozen_string_literal: true

require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/configs'
require_relative 'lib/objects/transaction_factory'
require_relative 'lib/objects/file_handler'
require_relative 'lib/objects/templater'
require_relative 'lib/objects/notification_service'
require_relative 'lib/objects/submission_service'
require_relative 'lib/objects/mailer'

ALMA_XML_OUTPUT_PATH = '/gilftpfiles/uga/finance/checkreq'

secrets      = Configs.read 'secrets'
defaults     = Configs.read 'defaults'
chartstrings = Configs.read 'chartstrings'

notifier = NotificationService.new secrets['slack_webhook_url']
mailer = Mailer.new notifier

mailer.send_test_message

exit
