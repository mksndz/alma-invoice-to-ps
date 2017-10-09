require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/configs'
require_relative 'lib/objects/transaction_factory'
require_relative 'lib/objects/file_handler'
require_relative 'lib/objects/templater'
require_relative 'lib/objects/notification_service'
require_relative 'lib/objects/submission_service'

secrets      = Configs.read 'secrets'
defaults     = Configs.read 'defaults'
vendors      = Configs.read 'vendors'
chartstrings = Configs.read 'chartstrings'

notifier = NotificationService.new secrets['slack_webhook_url']

file = FileHandler.get_latest

notifier.info "processing file #{}"

transactions = TransactionFactory.create_all_from(
                                                file,
                                                vendors,
                                                chartstrings
)

output = Templater.apply(
                     transactions,
                     defaults,
                     secrets
)

FileHandler.archive output
FileHandler.archive_source file

# SOAP processing
ss = SubmissionService.new secrets['endpoint_wsdl'], notifier
ss.transmit output

notifier.info 'Execution complete'