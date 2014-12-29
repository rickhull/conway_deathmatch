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

  test "add_points with multiple populations" do
    {c, width, height} = {ConwayDeathmatch, 5, 5}
    {val1, block1} = {'1', [[0,0], [0,1], [1,0], [1,1]]}
    {val2, block2} = {'2', [[2,2], [2,3], [3,2], [3,3]]}
    grid = c.new(width, height)
    |> c.add_points(block1, val1)
    |> c.add_points(block2, val2)
    block1 |> Enum.each(fn([x,y]) -> assert c.cell(grid, x, y) == val1 end)
    block2 |> Enum.each(fn([x,y]) -> assert c.cell(grid, x, y) == val2 end)
  end

  test "render width/height orientation" do
    {c, width, height} = {ConwayDeathmatch, 5, 1}
    rendered = c.new(width, height) |> c.render
    assert String.length(rendered) == 5
    assert length(String.split(rendered)) == 1 # no whitespace (inc newlines)

    {width, height} = {1, 5}
    rendered = c.new(width, height) |> c.render
    line_list = String.split(rendered, "\n")
    assert length(line_list) == 5
    assert String.length(hd(line_list)) == 1
  end

  test "alive/1" do
    c = ConwayDeathmatch
    grid = c.new(1, 1)
    neighbors = [grid.dead, grid.dead, 1, 2, 3]
    assert length(c.alive(neighbors)) == 3
  end

  test "majority/1" do
    c = ConwayDeathmatch
    grid = c.new(1, 1)
    neighbors = [grid.dead, grid.dead, grid.dead, 1, 1, 2, 3]
    assert c.majority(neighbors) == grid.dead
    assert c.majority(c.alive(neighbors)) == 1
  end

  test "tor/2" do
    c = ConwayDeathmatch
    assert c.tor(-2, 5) == 3
    assert c.tor(99, 3) == 0
    assert c.tor(6, 5) == 1
    assert c.tor(0, 5) == 0
    assert c.tor(-2, 1) == 0
    assert c.tor(-3, 2) == 1
  end

  test "CLI.parse_args/1" do
    c = ConwayDeathmatch
    assert ConwayDeathmatch.CLI.parse_args([]) == c.default_options
  end

  test "CLI.parse_args/1 bad_args" do
    cli = ConwayDeathmatch.CLI
    import ExUnit.CaptureIO
    bad_args = ["blammo", "--blammo", "whap", "--whap", "zip", "--zip"]
    Enum.each(bad_args, fn(_arg) -> # a slimy trick to do multiple iterations
                f = fn() -> cli.parse_args(bad_args |> Enum.sample(3)) end
                assert (capture_io(f) |> String.length) > 20
              end)
  end

  test "CLI.shape_points/1" do
    cli = ConwayDeathmatch.CLI
    assert cli.shape_points("p 1 2 p 3 4 p 5 6") == [[1,2], [3,4], [5,6]]
  end
end
