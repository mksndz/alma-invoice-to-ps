require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/configs'
require_relative 'lib/objects/transaction_factory'
require_relative 'lib/objects/file_handler'
require_relative 'lib/objects/templater'
require_relative 'lib/objects/notification_service'
require_relative 'lib/objects/submission_service'

secrets      = Configs.read 'secrets'
defaults     = Configs.read 'defaults'
chartstrings = Configs.read 'chartstrings'

notifier = NotificationService.new secrets['slack_webhook_url']

file = FileHandler.get_latest

unless file
  puts 'No file(s) found'
  fail
end

notifier.info "Processing file `#{file.path}`."

transactions = TransactionFactory.create_all_from(
                                                file,
                                                chartstrings
)

output = Templater.apply(
                     transactions,
                     defaults,
                     secrets
)

FileHandler.archive output.gsub(secrets['s_pass'],'*******')

ss = SubmissionService.new secrets['endpoint_url'], notifier
response = ss.transmit output

if response.success?
  if response.http.headers.key? 'transactionid'
    transaction_id = response.http.headers['transactionid']
    notifier.info "Execution completed successfully. PS Transaction ID: `#{transaction_id}`."
  else
    notifier.info 'Execution completed successfully, but no PD Transaction ID provided.'
  end
  FileHandler.archive_source file
else
  notifier.error 'Transaction failed'
end



