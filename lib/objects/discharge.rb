# frozen_string_literal: true

# represent a discharge
class Discharge
  attr_accessor :chartstring
  attr_accessor :number
  attr_accessor :amount
  attr_accessor :fiscal_year
  def initialize(number, chartstring, amount, fy)
    self.chartstring = chartstring
    self.number = number
    self.amount = amount
    self.fiscal_year = fy
  end
end