require "spec_helper"

describe BetterFx::Client do
  subject { described_class.new }

  let(:value) { 1 }
  let(:timestamp) { 12_345 }
  let(:dimensions) { [{ env: BetterFx.configuration.current_environment }] }
  let(:mock_fx_client) { FxMocks::MockFxClient.new }

  before do
    allow(SignalFx).to receive(:new).and_return mock_fx_client
  end

  describe "#gauge" do
    it "sends the value to SignalFx for the specified gauge" do
      expect(mock_fx_client).
        to receive(:bf_xmit).
        with(gauges: [
               hash_including(
                 metric: "sample_gauge",
                 value:  value
               ),
             ])
      subject.gauge :sample_gauge, value: value
    end

    describe "specifying the timestamp" do
      let(:timestamp) { 1111 }
      it "sends the user specified timestamp as a string" do
        expect(mock_fx_client).
          to receive(:bf_xmit).
          with(gauges: [
                 hash_including(
                   metric:    "sample_gauge",
                   value:     value,
                   timestamp: timestamp.to_s
                 ),
               ])

        subject.gauge :sample_gauge, value: value, timestamp: timestamp
      end
    end

    describe "specifying dimensional metadata" do
      let(:dimensions) { [{ size: "Large" }] }
      it "sends the user specified dimensional metadata" do
        expect(mock_fx_client).
          to receive(:bf_xmit).
          with(gauges: [
                 hash_including(
                   metric:     "sample_gauge",
                   value:      value,
                   dimensions: dimensions
                 ),
               ])

        subject.gauge :sample_gauge, value: value, dimensions: dimensions
      end
    end
  end

  describe "#increment_counter" do
    it "sends the default incremental value to SignalFx for the specified counter" do
      expect(mock_fx_client).
        to receive(:bf_xmit).
        with(counters: [
               hash_including(
                 metric: "sample_counter",
                 value:  value
               ),
             ])

      subject.increment_counter :sample_counter
    end

    describe "specifying the incremental value" do
      let(:value) { 25 }
      it "sends the user specified incremental value" do
        expect(mock_fx_client).
          to receive(:bf_xmit).
          with(counters: [
                 hash_including(
                   metric: "sample_counter",
                   value:  value
                 ),
               ])

        subject.increment_counter :sample_counter, value: 25
      end
    end

    describe "specifying the timestamp" do
      let(:timestamp) { 1111 }
      it "sends the user specified timestamp as a string" do
        expect(mock_fx_client).
          to receive(:bf_xmit).
          with(counters: [
                 hash_including(
                   metric:    "sample_counter",
                   value:     value,
                   timestamp: timestamp.to_s
                 ),
               ])

        subject.increment_counter :sample_counter, timestamp: timestamp
      end
    end

    describe "specifying dimensional metadata" do
      let(:dimensions) { [{ size: "Large" }] }
      it "sends the user specified dimensional metadata" do
        expect(mock_fx_client).
          to receive(:bf_xmit).
          with(counters: [
                 hash_including(
                   metric:     "sample_counter",
                   value:      value,
                   dimensions: dimensions
                 ),
               ])

        subject.increment_counter :sample_counter, dimensions: dimensions
      end
    end
  end
end
