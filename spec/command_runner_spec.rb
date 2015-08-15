require 'spec_helper'

describe Envme::CommandRunner do
  context "#build_cmd" do
    it "returns a the expected command" do
      command  = Envme::CommandRunner.build_cmd('test/prefix')
      expected = "envconsul -once -consul localhost:8500 -prefix test/prefix -upcase -token anonymous -sanitize env"

      expect(command).to eq(expected)
    end
  end
end
