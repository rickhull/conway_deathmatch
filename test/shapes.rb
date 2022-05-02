# require_relative './spec_helper'

# require 'conway_deathmatch'
require 'conway_deathmatch/shapes'
require 'minitest/autorun'

#ALIVE = ConwayDeathmatch::ALIVE
#DEAD = ConwayDeathmatch::DEAD
Shapes = ConwayDeathmatch::Shapes

describe Shapes do
  it "recognizes acorn" do
    expect(Shapes.classic.fetch("acorn")).must_be_instance_of Array
  end
end
