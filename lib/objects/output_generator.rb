require 'yaml'
require 'csv'

class OutputGenerator
  OUTPUT_PATH = 'output/'.freeze
  def initialize(invoices)
    @defaults = YAML.load_file('config/secrets.yml')['default_values']
    @data = []
    invoices.each do |invoice|
      add_lines_from invoice
    end
  end

  def generate
    return false unless @data.length > 0
    output_filename = File.join(
        OUTPUT_PATH,
        "alma_invoice_#{Time.now.strftime('%Y%m%d')}.csv"
    )
    CSV.open(
        output_filename,
        'w',
        quote_char: '"',
        force_quotes: true
    ) do |csv|
      @data.each do |invoice_row|
        csv << invoice_row
      end
    end
    File.new output_filename
  end

  private

  def add_lines_from(invoice)
    invoice.line_items.each do |line_item|
      @data << line_for(line_item)
    end
  end

  def line_for(line_item)
    [
        line_item.invoice.number,
        line_item.invoice.date_for_file,
        line_item.invoice.vendor_id,
        line_item.invoice.gross_amount,
        line_item.number,
        line_item.description,
        line_item.amount,
        @defaults['gl_business_unit'],
        @defaults['account'],
        @defaults['operating_unit'],
        @defaults['product'],
        @defaults['fund_code'],
        @defaults['class_field'],
        @defaults['program_code'],
        @defaults['budget_reference']
    ]
  end
end