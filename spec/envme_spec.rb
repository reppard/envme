require 'spec_helper'

describe Envme do
  before(:each) do
    envconsul_data = [ 
      "COMPONENT_PARAM1=first_param",
      "COMPONENT_PARAM2=second PaRam",
      "ENVVAR_PARAM3=env var"
    ].join("\n")

    allow(Envme).to receive(:run_cmd) { envconsul_data }
  end

  context "#get_env_vars" do
    it "calls run_cmd and returns an array" do
      prefix = 'test/prefix'
      expect(Envme).to receive(:run_cmd).with(prefix)

      Envme.get_env_vars(prefix)
    end

    it "returns an Array" do
      prefix = 'test/prefix'

      env_vars = Envme.get_env_vars(prefix)
      expect(env_vars).to be_kind_of(Array)
    end
  end

  context "#get_vars" do
    it "returns only the values matching search params" do
      prefix = 'test/prefix'

      vars = Envme.get_vars(prefix, 'ENVVAR')
      expect(vars.size).to eq(1)
      expect(vars[0]).to eq('ENVVAR_PARAM3=env var')
      expect(vars).not_to include("COMPONENT_PARAM2=second PaRam")
    end

    it "can accept multiple search strings" do
      prefix = 'test/prefix'

      vars = Envme.get_vars(prefix, 'ENVVAR', 'COMPONENT')
      expect(vars.size).to eq(3)
      expect(vars[0]).to eq('COMPONENT_PARAM1=first_param')
    end
  end

  context "#limit_to_search" do
    it "limits to search" do
      vars = [ 'VAR_ONE=one', 
               'VAR_TWO=two',
               'VARTHREE=three' ]
      results = Envme.limit_to_search(vars, ['VARTHREE'])  
      
      expect(results.size).to eq(1)
      expect(results).not_to include(vars[0])
      expect(results).not_to include(vars[1])
    end
  end

  context "#sanitize_vars" do

    it "santitizes vars" do
      vars = [ 'VAR_ONE=one', 
               'VAR_TWO=two',
               'VARTHREE=three' ]
      results = Envme.sanitize_vars(vars, 'VAR')

      expect(results.size).to eq(3)
      expect(results[0]).to eq('ONE=one')
      expect(results[1]).to eq('TWO=two')
      expect(results[2]).to eq('VARTHREE=three')
    end

    it "search string can be lowercase" do
      vars = [ "VAR_ONE=one" ]
      results = Envme.sanitize_vars(vars, 'var')

      expect(results[0]).to eq('ONE=one')
    end
  end
end
