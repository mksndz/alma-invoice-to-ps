require 'savon'

class SubmissionService
  SUBMISSION_ACTION = :voucher_build
  def initialize(wsdl, notifier)
    @notifier = notifier
    @service = Savon.client(
        wsdl: wsdl,
        log_level: :debug,
        pretty_print_xml: true
    )
  end

  def transmit(body)
    @service.call(
                SUBMISSION_ACTION,
                xml: body
    )
  rescue Savon::SOAPFault => e
    msg = "SOAP Error: ```#{e.message}```"
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