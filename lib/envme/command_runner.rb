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

    def self.error_message
      [
        "No envconsul installation found. Make sure envconsul exists in your path.",
        "Visit https://github.com/hashicorp/envconsul/releases to download envconsul."
      ].join("\n")
    end

    private
    def self.run(prefix)
      begin
        `#{build_cmd(prefix)}`
      rescue Errno::ENOENT
        raise error_message
      end
    end
  end
end
