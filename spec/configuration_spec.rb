require './lib/envme/configuration.rb'

describe "Envme" do
  describe "configuration" do
    before(:each) do
      expect(Envme.configuration).to_not be_nil
      expect(Envme.configuration).to be_a Envme::Configuration
      Envme.configuration = Envme::Configuration.new
    end

    it "has configuration block"  do
      expect { |b| Envme.configure(&b) }.to yield_control
    end

    context "Default" do
      let(:config) { Envme.configuration }

      it "Returns a Diplmant::Configuration" do
        expect(config).to be_a Envme::Configuration
      end

      it "Returns a default URL" do
        expect(config.url).to_not be_nil
        expect(config.url.length).to be > 0
      end

      it "Returns a default token" do
        expect(config.acl_token).to_not be_nil
        expect(config.acl_token).to eq('anonymous')
      end

      it "Returns an empty options hash" do
        expect(config.options).to be_a(Hash)
        expect(config.options).to be_empty
      end
    end

    context "Custom Configuration" do
      it "Sets the correct configuration" do
        Envme.configure do |config|
          config.url = "google.com"
          config.acl_token = "f45cbd0b-5022-47ab-8640-4eaa7c1f40f1"
          config.options = {ssl: { verify: true }}
        end

        expect(Envme.configuration.url).to eq("google.com")
        expect(Envme.configuration.acl_token).to eq("f45cbd0b-5022-47ab-8640-4eaa7c1f40f1")
      end
    end
  end
end
