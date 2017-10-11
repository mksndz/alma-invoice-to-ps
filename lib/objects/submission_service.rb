require 'savon'

class SubmissionService
  SUBMISSION_ACTION = 'VOUCHER_BUILD'.freeze
  TARGET_NAMESPACE = 'http://xmlns.oracle.com/Enterprise/Tools/schemas/VOUCHER_BUILD.VERSION_3'.freeze
  def initialize(endpoint, notifier)
    @notifier = notifier
    @service = Savon.client(
        endpoint: endpoint,
        namespace: TARGET_NAMESPACE,
        log_level: :debug,
        pretty_print_xml: true
    )
  end

  def transmit(body)
    @service.call(
                :voucher_build,
                soap_action: 'VOUCHER_BUILD.VERSION_3',
                xml: body
    )
  rescue Savon::SOAPFault => e
    msg = "SOAP Error: ```#{e.message}: #{e.xml}```"
    @notifier.error msg
    fail msg
  rescue Savon::HTTPError => e
    msg = "HTTP Error: ```#{e.message}```"
    @notifier.error msg
    fail msg
  rescue StandardError => e
    msg = "Other Error: ```#{e.message}```"
    @notifier.error msg
    fail msg
  end
end