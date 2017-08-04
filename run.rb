require 'nokogiri'
require 'csv'
require_relative 'lib/objects/alma_xml_reader'
require_relative 'lib/objects/invoice'

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
