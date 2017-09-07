class Transaction
  attr_accessor :line_items
  attr_accessor :invoice_id
  attr_accessor :invoice_date
  attr_accessor :vendor
  attr_accessor :amount
  def initialize(invoice_node, vendor, chartstring)

  end
end