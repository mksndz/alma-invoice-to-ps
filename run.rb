require 'nokogiri'
require 'csv'
require_relative 'lib/objects/invoice'

file = nil
# get latest file
files = Dir['data/*.xml']
for f in files
  fo = File.open f
  file = fo if !file || (fo && fo.mtime > file.mtime)
end

# nogogirifi file
data = Nokogiri File.read(file.path)

# for each <invoice>
invoices = data.css('invoice')

number = invoices.length

ios = []
invoices.each do |invoice_node|
  ios << Invoice.new(invoice_node)
end

puts ios.length

