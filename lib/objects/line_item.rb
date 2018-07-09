# frozen_string_literal: true

require_relative 'discharge_factory'
require_relative 'alma_xml_reader'
require 'ostruct'

# represent an individual invoice line item
class LineItem
  attr_accessor :discharges
  attr_accessor :number
  attr_accessor :amount
  attr_accessor :alma_fund
  def initialize(node, chartstring)
    self.discharges = DischargeFactory.create_from node, chartstring
    self.number = AlmaXmlReader.get_value 'line_number', node
    self.alma_fund = alma_fund_info node
    self.amount = AlmaXmlReader.get_value 'total_price', node
  end

  def alma_fund_info(node)
    fund_info_list = AlmaXmlReader.get_value 'fund_info_list', node, true
    return 'Not Specified' unless fund_info_list.any?
    fund_desc = fund_info_list[0].css('name').inner_text
    fund_fy = fund_info_list[0].css('fiscal_period').inner_text
    "#{fund_desc} - #{fund_fy}"
  end
end