module BetterFx
  # Provides configuration management for the BetterFx gem
  class Configuration
    attr_accessor :signalfx_api_token

    def initialize
      @signalfx_api_token   = ENV["SIGNALFX_API_TOKEN"]
    end
  end
end