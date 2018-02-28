require_relative 'transaction'
require_relative 'alma_xml_reader'
class TransactionFactory
  def self.create_all_from(file, chartstrings, mailer)
    transactions = []
    AlmaXmlReader.invoice_nodes(file).each do |node|
      alma_chartstring  = AlmaXmlReader.chartstring_from node
      # ps_chartstring    = chartstrings[alma_chartstring]
      ps_chartstring = chartstrings['default'] # TODO use value of fund_info_list -> fund_info - if 'stf' then use stf fund
      unless ps_chartstring
        "No Chartstring found in lookup for: #{alma_chartstring}"
        next
      end
      transaction = Transaction.new(
          node,
          ps_chartstring
      )
      mailer.add_invoice_line transaction
      transactions << transaction
    end
    transactions
  end
end