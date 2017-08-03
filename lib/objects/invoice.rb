require_relative 'line_item'

class Invoice
  attr_accessor :line_items
  attr_accessor :number
  attr_accessor :date
  attr_accessor :gross_amount
  attr_accessor :vendor_id
  attr_accessor :business_unit_code
  attr_accessor :account_code
  attr_accessor :operating_unit_code
  attr_accessor :product_code
  attr_accessor :fund_code
  attr_accessor :class_field
  attr_accessor :program_code
  attr_accessor :budget_reference

  def initialize(invoice_node)
    self.number = invoice_node.css('unique_identifier').inner_html
    self.date = invoice_node.css('invoice_date').inner_html
    self.gross_amount = invoice_node.css('invoice_amount').css('sum').inner_html
    self.vendor_id = invoice_node.css('vendor_code').inner_html
    self.fund_code = invoice_node.css('fund_info_list').css('fund_info')[0].css('code').inner_html
    self.vendor_id = invoice_node.css('vendor_code').inner_html
    self.line_items = generate_line_items invoice_node.css('invoice_line_list')
  end

  def generate_line_items(line_items_node)
    line_items = []
    line_items_node.css('invoice_line').each do |line_node|
      line_items << LineItem.new(self, line_node)
    end
    line_items
  end

end