module Envme
  class Configuration
    attr_accessor :url, :acl_token, :options

    def initialize(url="localhost:8500", acl_token=nil, options = {})
      @url       = url
      @acl_token = acl_token
      @options   = options
    end
  end
end
