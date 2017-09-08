require_relative 'line_item'
require_relative 'alma_xml_reader'
class LineItemFactory
  def self.create_all_from(nodes, chartstring)
    nodes.map do |node|
      LineItem.new node, chartstring
    end
  end
end