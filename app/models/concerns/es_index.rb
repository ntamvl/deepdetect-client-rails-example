require 'active_support/concern'

module EsIndex
  extend ActiveSupport::Concern

  def self.index_name
    begin
      config_file_path = "#{Rails.root}/config/index.json"
      index_file = File.read(config_file_path)
      index_hash = JSON.parse(index_file)
      return index_hash["#{Rails.env}"]["name"]
    rescue Exception => e
      puts "Error in getting index.json. #{e.to_s}"
      return "pixai_production"
    end
  end

end
