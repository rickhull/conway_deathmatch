defmodule ConwayDeathmatchTest do
  use ExUnit.Case
  doctest ConwayDeathmatch

  test "ConwayDeathmatch.new/2" do
    {c, width, height} = {ConwayDeathmatch, 3, 4}
    struct = c.new(width, height)
    for x <- 0..(width - 1) do
      for y <- 0..(height - 1) do
        assert c.cell(struct, x, y) == struct.dead
      end
    end
  end

  test "ConwayDeathmatch.new/3 block" do
    {c, width, height} = {ConwayDeathmatch, 5, 5}
    block = [[1,1], [1,2], [2,1], [2,2]]
    alive = 0
    grid = c.new(width, height, block, alive)
    block |> Enum.each(fn([x, y]) ->
                         assert c.cell(grid, x, y) == alive
                       end)
  end

  test "ConwayDeathmatch.tick/2 block" do
    {c, width, height} = {ConwayDeathmatch, 5, 5}
    block = [[1,1], [1,2], [2,1], [2,2]]
    alive = 0
    grid = c.new(width, height, block, alive) |> c.tick
    # block should remain
    block |> Enum.each(fn([x, y]) ->
                         assert c.cell(grid, x, y) == alive
                       end)
  end

  test "ConwayDeathmatch.tick/2 acorn" do
    {c, width, height} = {ConwayDeathmatch, 10, 10}
    acorn = [[3,5], [4,3], [4,5], [6,4], [7,5], [8,5], [9,5]]
    acorn_tick = [[3,4], [4,4], [5,4], [7,4], [7,5], [8,4], [8,5], [8,6]]
    alive = 0
    grid = c.new(width, height, acorn, alive) |> c.tick
    acorn_tick |> Enum.each(fn([x,y]) ->
                              assert c.cell(grid, x, y) == alive
                            end)

  end

  test "toroidal behavior" do
    {c, width, height} = {ConwayDeathmatch, 5, 5}
    block = [[0,2], [0,3], [4,2], [4,3]]
    alive = 0
    grid = c.new(width, height, block, alive) |> c.tick
    # block should remain
    block |> Enum.each(fn([x,y]) ->
                         assert c.cell(grid, x, y) == alive
                       end)
  end
end
