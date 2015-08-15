require 'spec_helper'

describe Envme do
  context "#build_exports" do
    it "should take a collection and build a list of exports" do
      data = [ 'VAR_ONE=one', 'VAR_TWO=two', 'VARTHREE=three' ]
      expected = "export VAR_ONE=one\nexport VAR_TWO=two\nexport VARTHREE=three"

      expect(Envme.build_exports(data)).to eq(expected)
    end
  end
end
