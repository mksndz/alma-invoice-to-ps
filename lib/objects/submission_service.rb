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
    @notifier.error "SOAP Error: ```#{e.message}```"
  rescue Savon::HTTPError => e
    @notifier.error "HTTP Error: ```#{e.message}```"
  rescue StandardError => e
    @notifier.error "Other Error: ```#{e.message}```"
  end
end