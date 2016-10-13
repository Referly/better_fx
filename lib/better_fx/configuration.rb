module BetterFx
  # Provides configuration management for the BetterFx gem
  class Configuration
    attr_accessor :signalfx_api_token,
                  :supported_environments,
                  :current_environment,
                  :signalfx_metric_namespace

    def initialize
      @signalfx_api_token       = ENV["SIGNALFX_API_TOKEN"]
      @supported_environments   = [:production, :prod, "production", "prod"]
      @current_environment      = ENV["APP_ENV"] || :production
      @signalfx_metric_namespace = ENV["SIGNALFX_METRIC_NAMESPACE"] || :better_fx
    end
  end
end
