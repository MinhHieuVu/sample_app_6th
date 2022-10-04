require "csv"

class ZipService
  def self.zip(*files)
    output_file = Zip::OutputStream.write_buffer do |out|
      files.each do |e|
        out.put_next_entry(e.filename)
        out.print (e.perform)
      end
    end
    output_file.rewind
    output_file.read
  end
end
