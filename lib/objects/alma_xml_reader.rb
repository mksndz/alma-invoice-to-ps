require 'nokogiri'

class AlmaXmlReader
  INVOICE_NODE_NAME = 'invoice'.freeze
  def self.invoice_nodes(file)
    data = Nokogiri File.read(file.path)
    data.css(INVOICE_NODE_NAME)
  end
end