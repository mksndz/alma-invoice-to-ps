# frozen_string_literal: true

require 'mail'
require 'uri'

# sends Emails
class Mailer
  DEFAULT_TO_ADDRESS = 'mak@uga.edu'
  attr_reader :included_invoices
  attr_reader :invoices_csv
  attr_reader :errors

  def initialize(notifier)
    @included_invoices = []
    @invoices_csv = []
    @errors = []
    @notifier = notifier
  end

  def add_invoice_line(invoice)
    num = @included_invoices.length
    @included_invoices << invoice_notification_line(invoice, num)
    @invoices_csv << invoice_csv_line(invoice, num)
  end

  def add_error(message)
    @notifier.info message
    @errors << message
  end

  def send_test_message
    mail = Mail.new do
      from 'GIL Alma Integrations <gil@usg.edu>'
      to(DEFAULT_TO_ADDRESS)
      subject 'Test'
      body 'Cheese is Yummy!'
      add_file(
        filename: 'test.txt',
        content: 'What is your favorite cheese?'
      )
    end
    mail.delivery_method :sendmail
    mail.deliver
  rescue StandardError => e
    @notifier.info "Notification email could not be sent! Error: #{e}"
  end

  def send_finished_notification(addresses = [])
    message = <<MESSAGE
The latest Invoices data was successfully sent to PeopleSoft.

Included Invoices Info (#{@included_invoices.length}):

#{print_included_invoices}

Errors:
#{print_errors}

Have a nice day!
MESSAGE
    begin
      mail = Mail.new do
        from 'GIL Alma Integrations <gil@usg.edu>'
        to(addresses << DEFAULT_TO_ADDRESS)
        subject 'Libraries Invoices Sent to PeopleSoft'
        body message
        add_file(
          filename: "#{Time.now.strftime('%Y%m%d')}_ps_invoices.csv",
          content: print_invoices_csv
        )
      end
      mail.delivery_method :sendmail
      mail.deliver
    rescue StandardError => e
      @notifier.info "Notification email could not be sent! Error: #{e}"
    end
  end

  def print_included_invoices
    @included_invoices.join("\n")
  end

  def print_invoices_csv
    @invoices_csv.join("\n")
  end

  def print_errors
    @errors.any? ? @errors.join("\n") : 'None'
  end

  private

  def ps_accounts_used_info(invoice)
    chartstrings = invoice.line_items.map do |li|
      li.discharges[0].chartstring
    end
    str = ''
    cs_info = chartstrings.uniq.map do |cs|
      str += "#{cs.name} [#{cs.fund_code}/#{cs.class_field}/#{cs.program_code}]"
    end
    cs_info.join(', ')
  end

  def invoice_notification_line(invoice, num)
    num = (num + 1).to_s
    "#{num}. Vendor: #{invoice.vendor_name} (#{invoice.vendor_id})\n" \
      "#{' ' * num.length}  Invoice: No. #{invoice.invoice_id} for $#{format('%.2f', invoice.amount)} on #{invoice.invoice_date}\n" \
      "#{' ' * num.length}  Accounts Used: #{ps_accounts_used_info(invoice)}"
  end

  def invoice_csv_line(invoice, line)
    num = (line + 1).to_s
    # line, invoice id, amount, date, vendor name, vendor_id, accounts used
    "#{num}, '#{invoice.invoice_id}', #{format('%.2f', invoice.amount)}, '#{invoice.invoice_date}', '#{invoice.vendor_name}', '#{invoice.vendor_id}', '#{ps_accounts_used_info(invoice)}'"
  end
end