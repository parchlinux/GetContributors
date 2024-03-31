require "json"

module Config
  def self.read(file_path)
    JSON.parse(File.read(file_path))
  end
end
