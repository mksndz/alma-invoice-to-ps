require 'nokogiri'
require 'csv'
require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/invoice'
require_relative 'lib/objects/output_generator'

file = nil
files = Dir['data/*.xml']
files.each do |f|
  fo = File.open f
  # get latest file
  file = fo if !file || (fo && fo.mtime > file.mtime)
end
ios = []
AlmaXmlReader.invoice_nodes(file).each do |invoice_node|
  ios << Invoice.new(invoice_node)
end
og = OutputGenerator.new ios
output_file = og.generate

puts 'Done'


