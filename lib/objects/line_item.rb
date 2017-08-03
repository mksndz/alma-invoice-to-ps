class LineItem
  attr_accessor :invoice
  attr_accessor :number
  attr_accessor :description
  attr_accessor :amount

  def initialize(invoice, line_item_node)
    self.invoice = invoice
    self.number = line_item_node.css('line_number').inner_html
    self.description = line_item_node.css('po_line_info').css('po_line_title').inner_html
    self.amount = line_item_node.css('fund_info_list').css('fund_info')[0].css('amount').css('sum').inner_html
  end
end