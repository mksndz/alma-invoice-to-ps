# frozen_string_literal: true

require 'nokogiri'

# Utility class to read from Alma XML
class AlmaXmlReader
  INVOICE_NODE_NAME = 'invoice'
  LINE_ITEM_NODE_NAME = 'invoice_line'
  FUND_INFO_NODE_NAME = 'fund_info'
  VENDOR_NODE_NAME = 'vendor_FinancialSys_Code'
  CHARTSTRING_NODE_NAME = 'fund_type_desc'
  FUND_TYPE_NODE = 'fund_type_desc'

  def self.invoice_nodes(file)
    data = Nokogiri File.read(file)
    data.css(INVOICE_NODE_NAME)
  end

  def self.line_item_nodes_from(invoice_node)
    invoice_node.css(LINE_ITEM_NODE_NAME)
  end

  def self.fund_info_nodes_from(line_item_node)
    line_item_node.css(FUND_INFO_NODE_NAME)
  end

  def self.vendor_from(invoice_node)
    get_value VENDOR_NODE_NAME, invoice_node
  end

  def self.chartstring_from(invoice_node)
    get_value CHARTSTRING_NODE_NAME, invoice_node
  end

  def self.get_value(node_name, node, noko = false)
    if noko
      node.css node_name
    else
      node.css(node_name).inner_text
    end
  end

  def self.fund_type_from(node)
    fund_info_nodes_from(node).first.css(FUND_TYPE_NODE).inner_text
  end
end