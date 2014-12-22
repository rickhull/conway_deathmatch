defmodule ConwayDeathmatch do
  @dead '.'
  defstruct grid: [[]], width: 0, height: 0, dead: @dead

  #def new(file) do
  #  lines = File.stream! file
  #  height = Enum.count lines
  #  width = lines |> Enum.max_by(&String.length/1) |> String.length
  #  grid = Enum.map lines, &(parse_line &1, width)
  #  %ConwayDeathmatch{grid: grid, width: width, height: height}
  #end
  def new(width, height) do
    grid = for _ <- 0..(width - 1) do
      for _ <- 0..(height - 1) do
        @dead
      end
    end
    %ConwayDeathmatch{grid: grid, width: width, height: height}
  end
  def new(width, height, points, val \\ 1) do
    new(width, height) |> add_points(points, val)
  end

  def add_points(conway, points, val) do
    grid = for row <- 0..(conway.height - 1) do
      for col <- 0..(conway.width - 1) do
        if HashSet.member?(Enum.into(points, HashSet.new), [row, col]) do
          val
        else
          conway |> cell(row, col)
        end
      end
    end
    %ConwayDeathmatch{conway | grid: grid}
  end

  def cell(conway, row, col) do
    conway.grid |> Enum.at(row) |> Enum.at(col)
  end

  def tick(conway) do
    grid = for row <- 0..(conway.height - 1) do
      for col <- 0..(conway.width - 1) do
        conway |> next_cell(row, col)
      end
    end
    %ConwayDeathmatch{conway | grid: grid}
  end

  def render(conway) do
    conway.grid |> transpose |> Enum.map(&Enum.join/1) |> Enum.join("\n")
  end

  defp transpose([[] | _]), do: []
  defp transpose(lists) do
    [Enum.map(lists, &hd/1) | transpose(Enum.map(lists, &tl/1))]
  end

  # single player only
  defp conway(cell_val, neighbors) do
    living = neighbors |> alive
    case {cell_val, length(living)} do
      {@dead, 3} -> hd(living)
      {v, 2} -> v
      {v, 3} -> v
      {_, _} -> @dead
    end
  end

  defp alive(neighbors) do
    neighbors |> Enum.reject(fn n -> n == @dead end)
  end

  defp group(neighbors) do
    Enum.group_by(neighbors, &(&1))
  end

  defp majority([head | tail]) do
    Enum.reduce(tail, {head, Dict.put(%{}, head, 1)},
      fn i, {lead, group} ->
        i_count = Dict.get(group, i, 0) + 1
        if i_count > Dict.get(group, lead) do
          {i, Dict.put(group, i, i_count)}
        else
          {lead, Dict.put(group, i, i_count)}
        end
      end)
    |> elem(0)
  end

  defp next_cell(conway, row, col) do
    conway |> cell(row, col) |> conway(neighbors(conway, row, col))
  end

  defp neighbors(conway, row, col) do
    for x <- (row-1)..(row+1), y <- (col-1)..(col+1), {x,y} != {row,col} do
      cell conway, tor(x, conway.width), tor(y, conway.height)
    end
  end

  # toroidal   tor(-2, 5) == 3
  defp tor(num, mod) when is_integer(num) and is_integer(mod) and mod > 0 do
    case rem(num, mod) do
      r when r >= 0 -> r
      r             -> r + mod
    end
  end

  def main(args) do
    {options, argv, errors} =
    OptionParser.parse(args,
                       strict: [width:  :integer,
                                height: :integer,
                                ticks:  :integer,
                                sleep:  :float,
                                points: :string,
                                step:   :boolean,
                                one:    :string,
                                two:    :string,
                                three:  :string,
                                renderfinal: :boolean,],
                       aliases: [x: :width,
                                 y: :height,
                                 n: :ticks,
                                 s: :sleep,
                                 p: :points,
                                 g: :step,
                                 r: :renderfinal,])

    unless Enum.empty? errors do
      errors |> Enum.each(fn t -> IO.puts "warning: #{elem(t, 0)} ignored" end)
    end
    unless Enum.empty? argv do
      argv |> Enum.each(fn s -> IO.puts "warning: #{s} ignored" end)
    end
    width = options[:width] || 70
    height = options[:height] || 40
    #shapes = options[:points] || "acorn 50 18"
    #slp = options[:sleep] || 0.02
    #num_ticks = options[:ticks]
    #render_continuous = num_ticks || options[:renderfinal]

    grid = new(width, height, [[0,0], [0,1], [0,2], [0,3]])


    IO.inspect grid
    IO.puts grid |> render
    IO.puts ""
    IO.puts grid |> tick |> render
  end
end
