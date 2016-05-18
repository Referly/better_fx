require "spec_helper"

describe BetterFx do
  describe "configuring BetterFx" do
    describe ".configure" do
      it "yields an instance of BetterFx::Configuration to the provided configuration block" do
        expect { |b| BetterFx.configure(&b) }.to yield_with_args BetterFx::Configuration
      end
      describe "configurable attributes" do
        {
          signalfx_api_token:     "123sdfss",
          supported_environments: [:production, :staging],
          current_environment:    :development,
        }.each do |k, v|
          describe k.to_s do
            let(:key) { k }
            let(:value) { v }

            let(:configure_block) do
              proc do |config|
                config.send "#{key}=", value
              end
            end

            it "is configurable" do
              described_class.configure(&configure_block)

              expect(described_class.configuration.public_send(k)).to eq v
            end
          end
        end
      end
      it "allows the configuration to be reset" do
        described_class.configure do |c|
          c.signalfx_api_token = "original_api_token"
        end
        first_configuration = described_class.configuration

        described_class.configure(reset: true) do |c|
          c.current_environment = :staging
        end

        expect(described_class.configuration).not_to eq first_configuration
        expect(described_class.configuration.signalfx_api_token).not_to eq "original_api_token"
        expect(described_class.configuration.current_environment).to eq :staging
      end
    end
  end

  describe "accessing the current BetterFx configuration" do
    describe ".configuration" do
      context "when the BetterFx has been previously configured" do
        before do
          described_class.configure
        end

        it "is the current configuration of the BetterFx" do
          expected_configuration = described_class.instance_variable_get :@configuration

          expect(described_class.configuration).to eq expected_configuration
        end
      end

      context "when the BetterFx has not been previously configured" do
        it "sets the current configuration to a new instance of Configuration" do
          described_class.configuration

          expect(described_class.instance_variable_get(:@configuration)).to be_a BetterFx::Configuration
        end

        it "returns the new Configuration instance" do
          expect(described_class.configuration).to eq described_class.instance_variable_get :@configuration
        end
      end
    end
  end
end
