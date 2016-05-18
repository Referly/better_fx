require "signalfx"
# Monkey patch the SignalFxClient to alias the #send method to as #bf_xmit
SignalFxClient.send :alias_method, :bf_xmit, :send
require_relative "better_fx/configuration"
require_relative "better_fx/client"
module BetterFx
  class << self
    # Allows the user to set configuration options
    #  by yielding the configuration block
    #
    # @param opts [Hash] an optional hash of options, supported options are `reset: true`
    # @return [Configuration] the current configuration object
    def configure(opts = {})
      @configuration = nil if opts.key?(:reset) && opts[:reset]
      yield(configuration) if block_given?
      configuration
    end

    # Returns the singleton class's configuration object
    #
    # @return [Configuration] the current configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    # Returns true if BetterFx has been configured, false otherwise
    #
    # @return [Bool] true if BetterFx is configured, false otherwise
    def configured?
      !@configuration.nil?
    end
  end
end
