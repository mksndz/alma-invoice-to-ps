require_relative 'discharge_factory'
require_relative 'alma_xml_reader'
require 'ostruct'
class LineItem
  attr_accessor :discharges
  attr_accessor :number
  attr_accessor :amount
  def initialize(node, chartstring)
    self.discharges = DischargeFactory.create_from node, chartstring
    self.number = AlmaXmlReader.get_value 'line_number', node
    self.amount = AlmaXmlReader.get_value 'total_price', node
  end
end