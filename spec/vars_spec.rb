require 'spec_helper'

describe Envme::Vars do
  before(:each) do
    envconsul_data = [
      "COMPONENT_PARAM1=first_param",
      "COMPONENT_PARAM2=second PaRam",
      "ENVVAR_PARAM3=env var"
    ].join("\n")

    allow(Envme::CommandRunner).to receive(:run) { envconsul_data }
  end

  context "#get_all" do
    it "calls run and returns an array" do
      prefix = 'test/prefix'
      expect(Envme::CommandRunner).to receive(:run).with(prefix)

      Envme::Vars.get_all(prefix)
    end

    it "returns an Array" do
      prefix = 'test/prefix'

      env_vars = Envme::Vars.get_all(prefix)
      expect(env_vars).to be_kind_of(Array)
    end
  end

  context "#get_limited" do
    it "returns only the values matching search params" do
      prefix = 'test/prefix'

      vars = Envme::Vars.get_limited(prefix, 'ENVVAR')
      expect(vars.size).to eq(1)
      expect(vars[0]).to eq('ENVVAR_PARAM3=env var')
      expect(vars).not_to include("COMPONENT_PARAM2=second PaRam")
    end

    it "can accept multiple search strings" do
      prefix = 'test/prefix'

      vars = Envme::Vars.get_limited(prefix, 'ENVVAR', 'COMPONENT')
      expect(vars.size).to eq(3)
      expect(vars[0]).to eq('COMPONENT_PARAM1=first_param')
    end
  end

  context "#sanitize" do
    it "santitizes vars" do
      vars = [ 'VAR_ONE=one',
               'VAR_TWO=two',
               'VARTHREE=three' ]
      results = Envme::Vars.sanitize(vars, 'VAR')

      expect(results.size).to eq(3)
      expect(results[0]).to eq('ONE=one')
      expect(results[1]).to eq('TWO=two')
      expect(results[2]).to eq('VARTHREE=three')
    end

    it "search string can be lowercase" do
      vars = [ "VAR_ONE=one" ]
      results = Envme::Vars.sanitize(vars, 'var')

      expect(results[0]).to eq('ONE=one')
    end
  end
end
