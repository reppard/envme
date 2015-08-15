module Envme
  class CommandRunner
    def self.build_cmd(prefix)
      [
        "envconsul -once",
        "-consul #{Envme.configuration.url}",
        "-prefix #{prefix} -upcase",
        "-token #{Envme.configuration.acl_token} -sanitize env"
      ].join(' ')
    end

    private
    def run(prefix)
      `#{build_cmd(prefix)}`
    end
  end
end
