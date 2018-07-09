# frozen_string_literal: true

require 'yaml'

# config reading utility class
class Configs
  CONFIG_DIR = 'config'
  def self.read(name)
    YAML.load_file "#{CONFIG_DIR}/#{name}.yml"
  rescue StandardError => e
    fail "Couldn't read config for #{name}. Exiting."
  end
end