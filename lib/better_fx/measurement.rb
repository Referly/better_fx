require "active_support/inflector"
module BetterFx
  # A mixin for creating declarative telemetry to send
  # to BetterFx (plan being to move this into BetterFx)
  module Measurement
    def self.included(mod)
      mod.extend ClassMethods
      mod.send :include, InstanceMethods
    end
    # Instance methods
    module InstanceMethods
      # Perform a measurement and send the results
      #  to the Telemetry system
      #
      # @param name [String, Symbol] the name of the measurement to perform
      def measure(name, _opts = {})
        name = name.to_s
        prok = self.class.measurements[name]
        value = prok ? prok.call(self) : nil
        return unless value
        fq_gauge_name = self.class.gauge_name name
        self.class.bfx.gauge fq_gauge_name, value: value
        value
      end
    end

    # Class methods
    module ClassMethods
      # Defines a measurement
      #
      # @param name [String, Symbol] the name of the measurement (measurement names
      #  are inherently namespaced by class so should just use a meaningful name. It will
      #  show up in the telemetry system as gauge.$CLASS.name)
      # @param blk [Block] you must provide a block which contains the code for performing
      #  the measurement; the block must return the value of the measurement
      def measurement(name, _opts = {}, &blk)
        name = name.to_s
        @_measurements ||= {}
        @_measurements[name] = blk
      end

      # Returns all of the defined measurements
      #
      # @return [Hash] the measurements with names as keys and procs as values
      def measurements
        @_measurements
      end

      # A memoized BetterFx Client instance
      #
      # @return [BetterFx::Client] a BetterFx client
      def bfx
        @_bfx ||= BetterFx::Client.new
      end

      # Generates the fully qualified gauge name
      #
      # @param measurement_name [String, Symbol] the name of the measurement
      def gauge_name(measurement_name)
        "#{BetterFx.configuration.signalfx_metric_namespace}.#{name.to_s.underscore.downcase}.#{measurement_name}".tr "/", "."
      end
    end
  end
end
