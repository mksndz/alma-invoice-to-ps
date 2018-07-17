# frozen_string_literal: true

require_relative 'discharge'
require_relative 'alma_xml_reader'
require 'ostruct'

# generate discharges
class DischargeFactory
  def self.create_from(node, chartstring)
    i = 0
    AlmaXmlReader.fund_info_nodes_from(node).map do |d|
      i += 1
      Discharge.new(
        i,
        OpenStruct.new(chartstring),
        AlmaXmlReader.get_value(
          'sum',
          AlmaXmlReader.get_value('amount', d, true).first
        ),
        AlmaXmlReader.get_value('fiscal_period', d)[-4..-1]
      )
    end
  end
end