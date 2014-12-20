defmodule ConwayDeathmatchTest do
  use ExUnit.Case
  doctest ConwayDeathmatch

  test "ConwayDeathmatch.new/3 empty" do
    {c, x_len, y_len} = {ConwayDeathmatch, 3, 4}
    grid = c.new([], x_len, y_len)
    assert is_tuple(grid)
    assert c.dim(grid) == {x_len, y_len}
    for x <- 0..(x_len - 1) do
      for y <- 0..(y_len - 1) do
        assert c.cell(grid, x, y) == 0
      end
    end
  end

  test "ConwayDeathmatch.new/3 block" do
    {c, x_len, y_len} = {ConwayDeathmatch, 5, 5}
    block = [[1,1], [1,2], [2,1], [2,2]]
    grid = c.new(block, x_len, y_len)
    block |> Enum.each(fn(point) ->
                           [x, y] = point
                           assert c.cell(grid, x, y) == 1
                         end)
  end

  test "ConwayDeathmatch.tick/2 block" do
    {c, x_len, y_len} = {ConwayDeathmatch, 5, 5}
    block = [[1,1], [1,2], [2,1], [2,2]]
    grid = c.new(block, x_len, y_len) |> c.tick
    # block should remain
    block |> Enum.each(fn(point) ->
                         [x, y] = point
                         assert c.cell(grid, x, y) == 1
                         # assert c.next_cell(grid, x, y) == 1
                       end)
  end

  test "ConwayDeathmatch.tick/2 acorn" do
    {c, x_len, y_len} = {ConwayDeathmatch, 10, 10}
    acorn = [[3,5], [4,3], [4,5], [6,4], [7,5], [8,5], [9,5]]
    acorn_tick = [[3,4], [4,4], [5,4], [7,4], [7,5], [8,4], [8,5], [8,6]]
    grid = c.new(acorn, x_len, y_len) |> c.tick
    acorn_tick |> Enum.each(fn(point) ->
                              [x, y] = point
                              assert c.cell(grid, x, y) == 1
                            end)

  end

  test "toroidal behavior" do
    {c, x_len, y_len} = {ConwayDeathmatch, 5, 5}
    block = [[0,2], [0,3], [4,2], [4,3]]
    grid = c.new(block, x_len, y_len) |> c.tick
    # block should remain
    block |> Enum.each(fn(point) ->
                         [x, y] = point
                         assert c.cell(grid, x, y) == 1
                         # assert c.next_cell(grid, x, y) == 1
                       end)
  end
end
