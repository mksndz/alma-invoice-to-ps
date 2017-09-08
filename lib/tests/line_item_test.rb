require 'minitest/autorun'
require_relative '../objects/invoice'
require_relative '../objects/line_item'

class LineItemTest < Minitest::Test
  def setup
    invoice = Invoice.new()
  end
end