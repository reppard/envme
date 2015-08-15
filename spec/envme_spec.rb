require 'spec_helper'

describe Envme do
  context "#build_exports" do
    it "takes a collection and builds a sorted list of exports" do
      data = [ 'B_TWO=two', 'A_ONE=one', 'VARTHREE=three' ]

      expected = "export A_ONE=one\nexport B_TWO=two\nexport VARTHREE=three"

      expect(Envme.build_exports(data)).to eq(expected)
    end
  end

  context "#file_builder" do
    it "takes a collection and builds a sorted list of exports" do
      data = [ 'B_TWO=two', 'A_ONE=one', 'VARTHREE=three' ]

      expected = [
        "echo A_ONE=one >> /some/file",
        "echo B_TWO=two >> /some/file",
        "echo VARTHREE=three >> /some/file"
      ].join("\n")

      expect(Envme.file_builder(data, '/some/file')).to eq(expected)
    end
  end
end
