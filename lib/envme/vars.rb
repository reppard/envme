module Envme
  class Vars < Envme::CommandRunner

    def self.get(prefix, *search_strings)
      env         = `env`.split("\n")
      consul_vars = run(prefix).split("\n") - env
      env_vars    = consul_vars.select{ |var| !var.split("=")[0].nil? }

      if search_strings.empty?
        env_vars
      else
        limit_to_search(env_vars, search_strings)
      end
    end

    def self.sanitize(vars, search)
      search = search.upcase

      vars.collect do |var|
        if var.split("=")[0].match(/^#{search}_/)
          var.gsub("#{search}_",'')
        else
          var
        end
      end
    end

    private
    def self.limit_to_search(vars, search_strings)
      vars.select do |var|
        search_strings.any? do |match|
          var.split("=")[0].include?(match.upcase)
        end
      end
    end
  end
end
