module BetterFx
  class Client
    attr_accessor :signalfx_client

    def initialize
      @signalfx_client = SignalFx.new configuration.signalfx_api_token
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
      timestamp ||= 1000 * Time.now.to_i
      dimensions << [{ env: configuration.current_environment }] if dimensions.empty?
      signalfx_client.send counters: [metric: counter_name,
                                      value: value,
                                      timestamp: timestamp.to_s, dimensions: dimensions]
    end
  end
end
