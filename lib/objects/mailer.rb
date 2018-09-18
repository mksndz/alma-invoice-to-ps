# frozen_string_literal: true

require 'net/smtp'
require 'uri'
require 'base64'

# sends Emails
class Mailer
  FROM_ADDRESS = 'gil@usg.edu'
  SMTP_SERVER = 'localhost'
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

  def send_finished_notification(addresses = [])
    csv_filename = "invoices_csv_#{Time.now.strftime('%Y%m%d')}.csv"
    encoded_csv = Base64.encode64 print_invoices_csv
    marker = 'AREAMARKER'
    recipients = addresses << DEFAULT_TO_ADDRESS
    message = <<MESSAGE
From: GIL Alma Integrations <#{FROM_ADDRESS}>
Subject: Libraries Invoices Sent to PeopleSoft
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary = #{marker}
--#{marker}

Content-Type: text/plain
Content-Transfer-Encoding:8bit

The latest Invoices data was successfully sent to PeopleSoft.

Included Invoices Info (#{@included_invoices.length}):

#{print_included_invoices}

As CSV:

#{print_invoices_csv}

Errors:
#{print_errors}

Have a nice day!
--#{marker}

Content-Type: multipart/mixed; name = \"#{csv_filename}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename = #{csv_filename}

#{encoded_csv}
--#{marker}--
MESSAGE
    email recipients, message
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

  def email(to, message)
    if to.is_a? Array
      to.each do |address|
        email address, message
      end
    elsif to.is_a?(String) && to =~ URI::MailTo::EMAIL_REGEXP
      begin
        Net::SMTP.start(SMTP_SERVER, 25) do |smtp|
          smtp.send_message(message, FROM_ADDRESS, to)
        end
      rescue StandardError => e
        @notifier.info "Email could not be sent to #{to}. Exception: #{e}"
      end
    else
      @notifier.info "Bad email address encountered: #{to}"
    end
  end

end