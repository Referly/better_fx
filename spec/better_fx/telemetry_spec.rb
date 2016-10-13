require "spec_helper"

describe BetterFx::Measurement do
  module TestClasses
    class Telemetric
      include BetterFx::Measurement

      def inst_method
        "instance method found"
      end
    end
    class OtherTelemetric
      include BetterFx::Measurement
    end
  end

  let(:k1) { TestClasses::Telemetric }
  let(:k2) { TestClasses::OtherTelemetric }
  let(:mock_fx) { double "BetterFxClient", gauge: true }
  before do
    k1.instance_variable_set :@_bfx, nil
    k2.instance_variable_set :@_bfx, nil
    allow(BetterFx::Client).to receive(:new).and_return mock_fx
  end
  describe "defining a measurement" do
    describe ".measurement" do
      it "defines a new measurement of the specified name" do
        k1.measurement :foo do
          5
        end
        expect(k1.new.measure(:foo)).to eq 5
      end
      it "isolates measurements by class" do
        k1.measurement :foo do
          5
        end
        k2.measurement :foo do
          12
        end
        expect(k1.instance_variable_get(:@_measurements)["foo"]).to be_a Proc
        expect(k1.instance_variable_get(:@_measurements)["foo"].call).to eq 5
        expect(k2.instance_variable_get(:@_measurements)["foo"]).to be_a Proc
        expect(k2.instance_variable_get(:@_measurements)["foo"].call).to eq 12
      end
    end
  end

  describe "performing a measurement" do
    describe "#measure" do
      let(:prok) { proc { 123 } }
      let(:instance_of_k1) { k1.new }
      before do
        k1.measurement :foo, &prok
      end

      it "executes the proc associated with the measurement name" do
        expect(prok).to receive :call
        k1.new.measure :foo
      end

      it "sends the result of the proc to BetterFx" do
        expect(mock_fx).to receive(:gauge).with(k1.gauge_name(:foo), hash_including(value: 123))
        instance_of_k1.measure :foo
      end

      it "returns the result of the proc" do
        expect(instance_of_k1.measure(:foo)).to eq prok.call
      end

      it "yields the current instance to the block" do
        k1.measurement :bar, &:inst_method
        expect(instance_of_k1.measure(:bar)).to eq "instance method found"
      end
    end
  end
end
