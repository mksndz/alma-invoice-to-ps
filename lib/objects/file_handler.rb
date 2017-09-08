class FileHandler
  DATA_PATH = 'data'.freeze
  OUTPUT_PATH = 'output'
  ARCHIVE_PATH = 'archive'
  TIME = Time.now.strftime('%Y%m%d')
  def self.get_latest
    file = nil
    files = Dir["#{DATA_PATH}/*.xml"]
    files.each do |f|
      fo = File.open f
      # get latest file
      file = fo if !file || (fo && fo.mtime > file.mtime)
    end
    file
  end
  def self.archive(xml)
    output_path = File.join(DATA_PATH, OUTPUT_PATH, "invoice_to_ps_#{TIME}.xml")
    File.write output_path, xml
  end
  def self.archive_source(file)
    archive_path = File.join(DATA_PATH, ARCHIVE_PATH, "alma_invoices_#{TIME}.xml")
    File.rename file, archive_path
  end
end