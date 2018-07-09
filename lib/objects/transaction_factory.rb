# frozen_string_literal: true

require_relative 'transaction'
require_relative 'alma_xml_reader'

# Assembles Transactions from Alma XML file and returns Transaction objects
class TransactionFactory
  def self.create_all_from(file, chartstrings, mailer, notifier)
    transactions = []
    AlmaXmlReader.invoice_nodes(file).each do |node|
      alma_fund_type_desc = AlmaXmlReader.fund_type_from(node)
      ps_chartstring = if alma_fund_type_desc == 'Student Technology Fee'
                         chartstrings['stf']
                       elsif alma_fund_type_desc == 'General'
                         chartstrings['default']
                       end
      unless ps_chartstring
        notifier.info "No Chartstring found in lookup for: #{alma_fund_type_desc}"
        next
      end
      transaction = Transaction.new(node, ps_chartstring)
      mailer.add_invoice_line transaction
      transactions << transaction
    end
    transactions
  end
end