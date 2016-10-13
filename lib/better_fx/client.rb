require "signalfx"
module BetterFx
  class Client
    def initialize
      # if BetterFx has not been configured then run the default configuration
      BetterFx.configure unless BetterFx.configured?
    end

    # Increment a SignalFx counter (if the current environment is a supports using SignalFx)
    #
    # @params counter_name [Symbol, String] the name of the counter to be incremented
    # @params value [Fixnum] what the incremental amount should be (default of 1)
    # @params timestamp [Fixnum, String] the timestamp, in milliseconds since the unix epoch (defaults to the timestamp
    #   on the host running your code)
    # @params dimensions [Array<Hash>] the metadata dimensions to be associated with the counter
    def increment_counter(counter_name, value: 1, timestamp: nil, dimensions: [])
      return unless configuration.supported_environments.include? configuration.current_environment
      timestamp ||= default_timestamp
      dimensions << { env: configuration.current_environment } if dimensions.empty?
      signalfx_client.bf_xmit(counters: [
                                metric:     counter_name.to_s,
                                value:      value,
                                timestamp:  timestamp.to_s,
                                dimensions: dimensions,
                              ])
    end

    # Send a gauge measurement to SignalFx (if the current environment supports using SignalFx)
    #
    # @params gauge_name [Symbol, String] the name of the gauge to send a measurement of
    # @params value [Fixnum] the measured value
    # @params timestamp [Fixnum, String] the timestamp, in milliseconds since the unix epoch (defaults to the timestamp
    #  on the host running your code)
    # @params dimensions [Array<Hash>] the metadata dimensions to be associated with the gauge measurement
    def gauge(gauge_name, value: nil, timestamp: nil, dimensions: [])
      return unless configuration.supported_environments.include? configuration.current_environment
      timestamp ||= default_timestamp
      dimensions << { env: configuration.current_environment } if dimensions.empty?
      signalfx_client.bf_xmit(gauges: [
                                metric:     gauge_name.to_s,
                                value:      value,
                                timestamp:  timestamp.to_s,
                                dimensions: dimensions,
                              ])
    end

    private

    def default_timestamp
      1000 * Time.now.to_i
    end

    def signalfx_client
      SignalFx.new configuration.signalfx_api_token
    end

    def configuration
      BetterFx.configuration
    end
  end
end
