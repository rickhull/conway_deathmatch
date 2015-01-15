defmodule ConwayDeathmatch.CLI do
  @module_doc "lorem ipsum"
  import ConwayDeathmatch # TODO: default_options(), print()


  def main(args) do
    options = args |> parse_args |> process_options
    IO.inspect options # debug
    conway = new(options[:width],
                 options[:height],
                 options[:points])
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
      {[help: true], _, _} ->
        usage()
      {cmd_opts, [], []} ->
        Enum.into(cmd_opts, default_options())
      {cmd_opts, args, errors} ->
        arg_errors({Enum.into(cmd_opts, default_options()), args, errors})
      _ ->
        usage("unexpected options")
    end
  end

  def arg_errors({options, args, errors}) do
    errors |> Enum.each(fn({err,_}) -> IO.puts("warning: #{err} ignored") end)
    args |> Enum.each(fn(arg) -> IO.puts("warning: #{arg} ignored") end)
    options
  end

  def process_options(%{shapes: shapes} = o) when is_map(o) do
    Dict.put(o, :points, shape_points(shapes))
  end

  def shape_points(shape_str) do
    shape_str |> String.split |> Enum.chunk(3)
    |> Enum.map(fn([shape, x, y]) ->
                  case shape do
                    "p" -> [String.to_integer(x, 10), String.to_integer(y, 10)]
                    _ -> raise "unknown shape: #{shape}"
                  end
                end)
  end

  def usage(err \\ "") do
    IO.puts @module_doc
    String.first(err) and IO.puts "Error: #{err}"
    System.halt(0)
  end
end
