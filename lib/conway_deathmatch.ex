defmodule ConwayDeathmatch do
  @module_doc "lorem ipsum"
  @dead "."
  defstruct grid: [[]], width: 0, height: 0,
  dead: @dead, deathmatch: nil, ticks: 0

  def new(width, height) when is_integer(width) and width > 0 and is_integer(height) and height > 0 do
    grid = for _y <- 0..(height - 1) do
      for _x <- 0..(width - 1) do # inner loop is the initial address
        @dead
      end
    end
    %ConwayDeathmatch{grid: grid, width: width, height: height}
  end
  def new(width, height, points, val \\ 1) do
    new(width, height) |> add_points(points, val)
  end

  def add_points(conway, points, val) do
    grid = for y <- 0..(conway.height - 1) do
      for x <- 0..(conway.width - 1) do
        if HashSet.member?(Enum.into(points, HashSet.new), [x, y]) do
          val
        else
          conway |> cell(x, y)
        end
      end
    end
    %ConwayDeathmatch{conway | grid: grid}
  end

  def cell(conway, x, y) do
    conway.grid |> Enum.at(y) |> Enum.at(x)
  end

  def tick(conway) do
    grid = for y <- 0..(conway.height - 1) do
      for x <- 0..(conway.width - 1) do
        conway |> next_cell(x, y)
      end
    end
    %ConwayDeathmatch{conway | grid: grid, ticks: conway.ticks + 1}
  end

  def render(conway) do
    conway.grid |> Enum.map(&Enum.join/1) |> Enum.join("\n")
  end
  def print(conway, %{renderfinal: _rf}), do: conway
  def print(conway, _options) do
    IO.puts ""
    IO.puts conway.ticks
    IO.puts render(conway)
    conway
  end

  # TODO: switch on deathmatch
  def next_cell(conway, x, y) do
    cur = conway |> cell(x, y)
    case conway.deathmatch do
      _ -> cur |> next_cell_sp(neighbors(conway, x, y))
    end
  end

  # single player only
  def next_cell_sp(cell_val, neighbors) do
    living = neighbors |> alive
    case {cell_val, length(living)} do
      {@dead, 3} -> hd(living)
      {v, 2} -> v
      {v, 3} -> v
      {_, _} -> @dead
    end
  end

  def neighbors(conway, x, y) do
    for xn <- (x-1)..(x+1), yn <- (y-1)..(y+1), {xn,yn} != {x,y} do
      cell conway, tor(xn, conway.width), tor(yn, conway.height)
    end
  end

  def alive(neighbors) do
    neighbors |> Enum.reject(fn n -> n == @dead end)
  end

  def group(neighbors) do
    Enum.group_by(neighbors, &(&1))
  end

  def majority([head | tail]) do
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

  # toroidal   tor(-2, 5) == 3
  def tor(num, mod) when is_integer(num) and is_integer(mod) and mod > 0 do
    case rem(num, mod) do
      r when r >= 0 -> r
      r             -> r + mod
    end
  end

  def main(args) do
    options = args |> parse_args |> process_options
    conway = new(options[:width], options[:height], options[:points])
    loop(conway, options)
  end

  def parse_args(args) do
    options = OptionParser.parse(args,
                                 strict: [help: :boolean,
                                          width:  :integer,
                                          height: :integer,
                                          ticks:  :integer,
                                          sleep:  :float,
                                          shapes: :string,
                                          step:   :boolean,
                                          one:    :string,
                                          two:    :string,
                                          three:  :string,
                                          renderfinal: :boolean,],
                                 aliases: [h: :help,
                                           x: :width,
                                           y: :height,
                                           t: :ticks,
                                           s: :sleep,
                                           S: :shapes,
                                           p: :step,
                                           r: :renderfinal,])
    case options do
      {[help: true], _, _}     -> :help
      {cmd_opts, [], []}       -> Enum.into(cmd_opts, default_options())
      {cmd_opts, args, errors} ->
        {Enum.into(cmd_opts, default_options()), args, errors}
      _ -> :help
    end
  end

  def shape_points(shape_str) do
    shape_str |> String.split |> Enum.chunk(3)
    |> Enum.map(fn([shape, x, y]) ->
                  case shape do
                    "p" -> [int(x), int(y)]
                    _ -> raise "unknown shape: #{shape}"
                  end
                end)
  end

  def int(bin) when is_binary(bin) do
    case Integer.parse(bin) do
      {int, _} when is_integer(int) -> int
      _ -> raise "bad integer: #{bin}"
    end
  end

  def sleep(conway, %{sleep: s}) when s == 0, do: conway
  def sleep(conway, %{sleep: s}), do: :timer.sleep(s) && conway

  def default_options do
    %{width: 70,
      height: 40,
      shapes: "p 1 2 p 3 4 p 5 6 p 7 8",
      sleep: 20}
  end

  def loop(conway, options \\ default_options()) do
    conway |> tick |> print(options) |> sleep(options) |> loop(options)
  end

  def process_options(:help) do
    IO.puts @module_doc
    System.halt(0)
  end
  def process_options(%{shapes: shapes} = o) when is_map(o) do
    Dict.put(o, :points, shape_points(shapes))
  end
  def process_options({o, args, errors}) do
    errors |> Enum.each(fn t -> IO.puts "warning: #{elem(t, 0)} ignored" end)
    args |> Enum.each(fn s -> IO.puts "warning: #{s} ignored" end)
    process_options(o)
  end
end
