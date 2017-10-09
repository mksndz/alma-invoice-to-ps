require 'erb'
require 'ostruct'
class Templater
  TEMPLATE_PATH = 'lib/templates/ps.xml.erb'.freeze
  def self.apply(transactions, defaults, secrets)
    current_date = Time.now.strftime('%Y-%m-%d')
    template = ERB.new File.open(TEMPLATE_PATH).read
    secrets = OpenStruct.new secrets
    defaults = OpenStruct.new defaults
    template.result(binding)
  rescue StandardError => e
    fail "Templater Error: #{e.message}"
  end
end