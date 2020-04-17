module Envme
  class << self
    attr_accessor :configuration
    attr_accessor :lib_path

    def require_libs(*libs)
      libs.each do |lib|
        require "#{lib_path}/#{lib}"
      end
    end

  end

  self.lib_path = File.expand_path "../envme", __FILE__
  require_libs "configuration", "command_runner", "vars"
  self.configuration ||= Envme::Configuration.new

  class << self
    def configure
      self.configuration ||= Envme::Configuration.new
      yield(configuration)
    end

    def build_exports(var_collection)
      var_collection.collect{ |var|
        "export #{var}"
      }.sort.join("\n")
    end

    def file_builder(var_collection, filename)
      var_collection.collect{ |var|
        "echo '#{var}' >> #{filename}"
      }.sort.join("\n")
    end
  end
end
