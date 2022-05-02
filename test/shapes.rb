require_relative 'helper'
require 'conway_deathmatch/shapes'

describe ConwayDeathmatch::Shapes do
  it "recognizes acorn" do
    expect(ConwayDeathmatch::Shapes.classic.fetch("acorn")).
      must_be_instance_of Array
  end
end
