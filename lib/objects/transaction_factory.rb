require_relative 'transaction'
require_relative 'alma_xml_reader'
class TransactionFactory
  def self.create_all_from(file, vendors, chartstrings)
    transactions = []
    AlmaXmlReader.invoice_nodes(file).each do |node|
      alma_vendor       = AlmaXmlReader.vendor_from node
      alma_chartstring  = AlmaXmlReader.chartstring_from node
      # ps_vendor         = vendors[alma_vendor]
      # ps_chartstring    = chartstrings[alma_chartstring]
      ps_vendor = vendors['test_vendor_1'] # TODO for testing
      ps_chartstring = chartstrings['default'] # TODO for testing
      unless ps_vendor
        "No Vendor found in lookup for: #{alma_vendor}"
        next
      end
      unless ps_chartstring
        "No Chartstring found in lookup for: #{alma_chartstring}"
        next
      end
      transactions << Transaction.new(
          node,
          ps_vendor,
          ps_chartstring
      )
    end
    transactions
  end
end