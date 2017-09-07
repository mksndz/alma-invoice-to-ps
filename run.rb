require 'nokogiri'
require 'csv'
require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/configs'
require_relative 'lib/objects/transaction'

file = nil
files = Dir['data/*.xml']
files.each do |f|
  fo = File.open f
  # get latest file
  file = fo if !file || (fo && fo.mtime > file.mtime)
end

@secrets      = Configs.read 'secrets'
@defaults     = Configs.read 'defaults'
@vendors      = Configs.read 'vendors'
@chartstrings = Configs.read 'chartstrings'

transactions = AlmaXmlReader.invoice_nodes(file).map do |node|
  vendor = AlmaXmlReader.vendor_from node
  chartstring = AlmaXmlReader.chartstring_from node
  Transaction.new node, vendor, chartstring
end

# Do templating

puts 'Done'


