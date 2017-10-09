require 'net/http'
require 'savon'
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

# SOAP processing
ap_client = Savon.client(
    wsse_auth: [
        secrets['s_user'],
        secrets['s_pass']
    ],
    wsdl: secrets['endpoint_wsdl'],
    log_level: :debug,
    pretty_print_xml: true
)

response = ap_client.call :voucher_build, xml: output
