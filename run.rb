require 'net/http'
require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/configs'
require_relative 'lib/objects/transaction_factory'
require_relative 'lib/objects/file_handler'
require_relative 'lib/objects/templater'

secrets      = Configs.read 'secrets'
defaults     = Configs.read 'defaults'
vendors      = Configs.read 'vendors'
chartstrings = Configs.read 'chartstrings'

file = FileHandler.get_latest

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

endpoint = URI secrets['endpoint']

begin
  response = Net::HTTP.post_form endpoint, xml: output # TODO: need doc from PS folks for endpoint
rescue StandardError => e
  fail("Could not reach PS endpoint: #{e.message}")
end

if response.code == '200'
  puts 'Submission accepted'
else
  puts "Submission error. Code: #{response.code} Message: #{response.message}"
end