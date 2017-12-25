class FileReader
  class FileReader::Error < StandardError
  end

  class FileReader::PermissionError < FileReader::Error
  end

  def initialize(filename)
    @file = File.open(filename, 'r')
  rescue Errno::EACCES => e
    raise FileReader::PermissionError, e.message
  rescue Errno::ENOENT => e
    raise ArgumentError, "File with a name `#{filename}` is not present"
  rescue IOError => e
    raise FileReader::Error, e.message
  end

  def each_line
    @file.each_line do |line|
      yield line.chomp
    end
  end

  def close
    @file.close
  end
end