# frozen_string_literal: true

require_relative 'line_item'
require_relative 'alma_xml_reader'
class LineItemFactory
  def self.create_all_from(nodes, chartstring)
    line_items = []
    nodes.each do |node|
      line_item = LineItem.new node, chartstring
      line_items << line_item if line_item.amount.to_f > 0.0
    end
    line_items
  end
end