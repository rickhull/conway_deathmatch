defmodule ConwayDeathmatch do
  def new(x_len, y_len) when is_integer(x_len) and x_len > 0 and  is_integer(y_len) and y_len > 0 do
    new_grid(x_len, y_len, fn(_, _) -> 0 end)
  end

  # e.g. points = [[1,2], [1,3], [1,4]]
  def new(points, x_len, y_len, val \\ 1) when is_list(points) and is_integer(x_len) and x_len > 0 and is_integer(y_len) and y_len > 0 and is_integer(val) and val > 0 do
    new_grid(x_len, y_len, fn(x, y) ->
               if HashSet.member?(Enum.into(points, HashSet.new), [x, y]) do
                 val
               else
                 0
               end
             end)
  end

  def dim(grid) when is_tuple(grid) do
    {grid |> tuple_size, grid |> elem(0) |> tuple_size}
  end

  def cell(grid, x, y) do
    grid |> elem(x) |> elem(y)
  end

  def tick(grid) do
    {x,y} = dim(grid)
    new_grid(x, y, &next_cell(grid, &1, &2))
  end

  # TODO: determine birthright
  defp conway(cell_val, neighbors) when is_integer(cell_val) and cell_val >= 0 and is_list(neighbors) do
    case {cell_val, neighbors |> Enum.count(fn x -> x != 0 end)} do
      {0, 3} -> 1 # birthright?
      {a, 2} -> a # birthright?
      {a, 3} -> a # birthright?
      {_, _} -> 0
    end
  end

  defp next_cell(grid, x, y) do
    conway(cell(grid, x, y), neighbors(grid, x, y))
  end

  # count of neighbors which aren't dead (0)
  defp alive_neighbors(list) when is_list(list) do
    list |> Enum.count(fn(x) -> x != 0 end)
  end

  # toroidal
  defp tor(x, x_len) when is_integer(x) and is_integer(x_len) and x_len > 0 do
    case rem(x, x_len) do
      r when r >= 0 -> r
      r             -> r + x_len
    end
  end

  defp neighbors(grid, x, y) when is_tuple(grid) and is_integer(x) and is_integer(y) do
    {x_len, y_len} = dim(grid)
    x = tor(x, x_len)
    y = tor(y, y_len)
    for xn <- (x-1)..(x+1) do
      xt = tor(xn, x_len)
      for yn <- (y-1)..(y+1) do
        cell grid, xt, tor(yn, y_len)
      end
    end |> List.flatten |> List.delete_at(4)
  end

  # creates new grid according populated according to fun
  defp new_grid(x_len, y_len, fun) when is_function(fun) and is_integer(x_len) and is_integer(y_len) and x_len > 0 and y_len > 0 do
    for x <- 0..(x_len - 1) do
      for y <- 0..(y_len - 1) do
        fun.(x, y)
      end
    end |> Enum.map(&List.to_tuple/1) |> List.to_tuple
  end
end
