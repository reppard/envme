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
  require_libs "configuration"
  self.configuration ||= Envme::Configuration.new

  class << self
    def configure
      self.configuration ||= Envme::Configuration.new
      yield(configuration)
    end

    def get_vars(prefix, *search_strings)
      env_vars = get_env_vars(prefix)

      limit_to_search(env_vars, search_strings)
    end

    def get_env_vars(prefix)
      run_cmd(prefix).split("\n")
    end

    def limit_to_search(vars, search_strings)
      vars.select do |var|
        search_strings.any? do |match|
          var.split("=")[0].include?(match.upcase)
        end
      end
    end

    def sanitize_vars(vars, search)
      search = search.upcase

      vars.collect do |var|
        if var.split("=")[0].match(/^#{search}_/)
          var.gsub("#{search}_",'')
        else
          var
        end
      end
    end

    def build_exports(var_collection)
      var_collection.collect{ |var| "export #{var}"}.join("\n")
    end

    def file_builder(var_collection, filename)
      var_collection.collect{ |var| "echo #{var} >> #{filename}"}.join("\n")
    end

    private
    def run_cmd(prefix)
      `envconsul -once \
      -consul #{self.configuration.url} \
      -prefix #{prefix} -upcase \
      -token #{self.configuration.acl_token} -sanitize env`
    end
  end
end
