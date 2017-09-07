require 'yaml'
class Configs
  CONFIG_DIR = 'config'.freeze
  def self.read(name)
    YAML.load_file "#{CONFIG_DIR}/#{name}.yml"
  rescue StandardError => e
    fail "Couldn't read config for #{name}. Exiting."
  end
end