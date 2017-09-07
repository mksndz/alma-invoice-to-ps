require 'nokogiri'
class AlmaXmlReader
  INVOICE_NODE_NAME = 'invoice'.freeze
  VENDOR_NODE_NAME = 'vendor_code'.freeze
  CHARTSTRING_NODE_NAME = 'fund_type_desc'.freeze
  def self.invoice_nodes(file)
    data = Nokogiri File.read(file.path)
    data.css(INVOICE_NODE_NAME)
  end
  def self.vendor_from(invoice_node)
    get_value VENDOR_NODE_NAME, invoice_node
  end
  def self.chartstring_from(invoice_node)
    get_value CHARTSTRING_NODE_NAME, invoice_node
  end
  def self.get_value(node_name, node)
    node.css(node_name).inner_text
  end
end