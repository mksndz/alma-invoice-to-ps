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

files = FileHandler.get_files_from secrets['alma_output_path']

unless files.any?
  puts 'No file(s) found'
  notifier.info 'No files found to process!'
  exit
end

# build transactions from all files
transactions = []
files.each do |file|
  notifier.info "UGA: Processing file `#{file}`."
  transactions += TransactionFactory.create_all_from(file, chartstrings, mailer,
                                                     notifier)
end

output = Templater.apply(transactions, defaults, secrets)

FileHandler.archive output.gsub(secrets['s_pass'], '*******')

ss = SubmissionService.new secrets['endpoint_url'], notifier
response = ss.transmit output

if response.success?
  if response.http.headers.key? 'transactionid'
    transaction_id = response.http.headers['transactionid']
    notifier.info "UGA: Invoices Sent: ```#{mailer.print_included_invoices}```"
    mailer.send_finished_notification secrets['finished_email_recipients']
    notifier.info "Execution completed successfully. PS Transaction ID: `#{transaction_id}`."
  else
    notifier.info 'Execution completed successfully, but no PD Transaction ID provided.'
  end
  FileHandler.archive_source files
else
  notifier.error 'Transaction failed'
end

exit
