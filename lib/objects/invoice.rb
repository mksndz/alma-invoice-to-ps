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
  end

end