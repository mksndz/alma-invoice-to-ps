# frozen_string_literal: true

# Utility class for handling Alma XML files
class FileHandler
  DATA_PATH = 'data'
  OUTPUT_PATH = 'output'
  ARCHIVE_PATH = 'archive'
  ORIGINALS_PATH = 'originals'

  def self.get_files_from(path)
    Dir["#{path}/*.xml"]
  end

  def self.archive(xml)
    output_path = File.join(DATA_PATH, OUTPUT_PATH,
                            "invoice_to_ps_#{Time.now.strftime('%Y%m%d')}.xml")
    File.write output_path, xml
  end

  def self.archive_source(files)
    files.each do |file|
      archive_path = File.join(DATA_PATH, ARCHIVE_PATH, ORIGINALS_PATH,
                               "alma_invoices_#{Time.now.strftime('%Y%m%d')}.xml")
      FileUtils.mv file, archive_path
    end
  end

  def self.remove_original(files)
    files.each do |file|
      File.delete file
    end
  end
end