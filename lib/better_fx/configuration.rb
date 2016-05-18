module BetterFx
  # Provides configuration management for the BetterFx gem
  class Configuration
    attr_accessor :signalfx_api_token,
                  :supported_environments,
                  :current_environment

    def initialize
      @signalfx_api_token       = ENV["SIGNALFX_API_TOKEN"]
      @supported_environments   = [:production]
      @current_environment      = :production
    end
  end
end
