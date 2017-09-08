require_relative 'discharge'
require_relative 'alma_xml_reader'
require 'ostruct'
class DischargeFactory
  def self.create_from(node, chartstring)
    i = 0
    AlmaXmlReader.fund_info_nodes_from(node).map do |d|
      i += 1
      Discharge.new(
          i,
          OpenStruct.new(chartstring),
          AlmaXmlReader.get_value('sum', d),
          AlmaXmlReader.get_value('fiscal_period', d)[-4..-1]
      )
    end
  end
end