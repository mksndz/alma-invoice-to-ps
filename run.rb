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

notifier.info "Processing file `#{file.path}`."

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

ss = SubmissionService.new secrets['endpoint_url'], notifier
response = ss.transmit output

transaction_id = response.http.headers[:transactionid]

if transaction_id
  notifier.info "Execution completed successfully. PS Transaction ID: `#{transaction_id}`."
  FileHandler.archive_source file
else
  notifier.error 'Transaction failed'
end



