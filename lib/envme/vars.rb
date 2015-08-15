module Envme
  class Vars < Envme::CommandRunner

    def self.get_all(prefix)
      env = `env`.split("\n")

      run(prefix).split("\n") - env
    end

    def self.get_limited(prefix, *search_strings)
      env_vars = get_all(prefix)

      limit_to_search(env_vars, search_strings)
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
