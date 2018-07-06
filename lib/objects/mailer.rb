require 'net/smtp'
require 'uri'

class Mailer
  FROM_ADDRESS = 'gil@usg.edu'.freeze
  SMTP_SERVER = 'localhost'.freeze
  DEFAULT_TO_ADDRESS = 'mak@uga.edu'.freeze
  attr_reader :included_invoices

  def initialize(notifier)
    @included_invoices = []
    @notifier = notifier
  end

  def add_invoice_line(invoice)
    @included_invoices << invoice_notification_line(invoice, @included_invoices.length)
  end

  def send_finished_notification(addresses = [])
    recipients = addresses << DEFAULT_TO_ADDRESS
    message = <<END
From: GIL Alma Integrations <#{FROM_ADDRESS}>
Subject: Invoice File Sent to PeopleSoft

The latest Invoices file was successfully sent to PeopleSoft.

Included Invoices Info (#{@included_invoices.length}):

#{print_included_invoices}

Have a nice day!
END
    email recipients, message
  end

  def print_included_invoices
    @included_invoices.join("\n")
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

  def invoice_notification_line(invoice, i)
    num =(i + 1).to_s
    "#{num}. Vendor: #{invoice.vendor_name} (#{invoice.vendor_id})\n" +
    "#{' ' * num.length}  Invoice: No. #{invoice.invoice_id} for $#{'%.2f' % invoice.amount} on #{invoice.invoice_date}\n" +
    "#{' ' * num.length}  Accounts Used: #{ps_accounts_used_info(invoice)}"
  end

  def email(to, message)
    if to.is_a? Array
      to.each do |address|
        email address, message
      end
    elsif to.is_a?(String) && to =~ URI::MailTo::EMAIL_REGEXP
      begin
        Net::SMTP.start(SMTP_SERVER, 25) do |smtp|
          smtp.send_message(
            message,
            FROM_ADDRESS,
            to
          )
        end
      rescue StandardError => e
        @notifier.info "Email could not be sent to #{to}. Exception: #{e}"
      end
    else
      @notifier.info "Bad email address encountered: #{to}"
    end
  end

end