require_relative 'line_item_factory'
require_relative 'alma_xml_reader'

class Transaction
  attr_accessor :line_items
  attr_accessor :invoice_id
  attr_accessor :invoice_date
  attr_accessor :vendor_id
  attr_accessor :amount

  def initialize(invoice_node, chartstring)
    self.line_items = LineItemFactory.create_all_from(
        AlmaXmlReader.line_item_nodes_from(invoice_node),
        chartstring
    )
    self.invoice_id = AlmaXmlReader.get_value 'invoice_number', invoice_node
    self.invoice_date = to_ps_date(
        AlmaXmlReader.get_value 'invoice_date', invoice_node
    )
    # self.vendor_id = AlmaXmlReader.get_value 'vendor_FinancialSys_Code', invoice_node #TODO: when we have VN numbers....
    self.vendor_id = %w(VN0078431 VN0077947 VN0007754).sample # TODO: for testing
    self.amount = AlmaXmlReader.get_value(
        'sum',
        AlmaXmlReader.get_value(
            'invoice_amount',
            invoice_node,
            true
        )
    )
  end

  private
  def to_ps_date(date)
    date_elements = date.split('/')
    "#{date_elements[2]}-#{date_elements[0]}-#{date_elements[1]}"
  end
end